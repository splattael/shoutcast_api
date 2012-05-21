require 'httparty'
require 'roxml'
require 'forwardable'

#
# Simple API for http://shoutcast.com.
#
# === Usage
#
#   Shoutcast.genres # => Genrelist
#
#   Shoutcast.search(:search => "Metal", :br => 128) # => Stationlist
module Shoutcast
  VERSION = "0.1.6"

  extend Forwardable
  extend self

  # Delegate module methods to +Fetcher+.
  def_delegators :Fetcher, :genres, :search

  # Talks to shoutcast.com.
  class Fetcher
    include HTTParty
    base_uri "http://yp.shoutcast.com"
    format :plain

    # Fetch all genres defined at shoutcast.com.
    #
    # === Usage
    #
    #   Fetcher.genres.each do |genre|
    #     p genre.name
    #   end
    #
    # See Genrelist or Genre
    #
    def self.genres
      fetch do |xml|
        Genrelist.from_xml xml
      end
    end

    # Search for available stations.
    #
    # === Usage
    #
    #   Fetcher.search(:name => "California", :br => 128, :mt => "audio/mpeg")
    #
    # === Search options
    #
    # * <tt>:name</tt> - Match station +name+
    # * <tt>:br</tt>   - Match +bitrate+
    # * <tt>:mt</tt>   - Match +media_type+
    #
    # See Stationlist or Station
    def self.search(options={})
      fetch(options) do |xml|
        Stationlist.from_xml xml
      end
    end

    private

    def self.fetch(options={}, &block) # :nodoc:
      options ||= {}
      options.update(:nocache => Time.now.to_f) unless options.key?(:nocache)
      data = get("/sbin/newxml.phtml", :query => options).body

      block.call(data)  unless data.empty?
    end
  end

  # Helper module. Include ROXML and defines some helper methods.
  module Xml
    def self.included(base)
      base.send(:include, ROXML)
      base.extend ClassMethods
    end

    module ClassMethods
      # Strip whitespaces.
      def trim
        proc { |v| v.to_s.strip.squeeze(" ") }
      end
    end
  end

  # Defines a shoutcast station.
  #
  # See Stationlist
  class Station
    include Xml
    # <station
    #   id="423873"
    #   name="www.deathmetal.at"
    #   mt="audio/mpeg"
    #   br="128"
    #   genre="METAL"
    #   ct="TITLE"
    #   lc="24"/>

    # URL ready to tune in.
    attr_accessor :tunein

    xml_reader :id,             :from => :attr, :as => Integer
    xml_reader :name,           :from => :attr, &trim
    xml_reader :media_type,     :from => '@mt'
    xml_reader :bitrate,        :from => '@br', :as => Integer
    xml_reader :genre,          :from => :attr, &trim
    xml_reader :current_title,  :from => '@ct', &trim
    xml_reader :listeners,      :from => '@lc', :as => Integer

    # Get last part of +media_type+.
    # Example: <i>mpeg</i> for <i>audio/mpeg</i>
    def type
      media_type.split('/').last || media_type
    end

    # String representation of this station
    def to_s
      "#%10d %3d %40s %7d %50s" % [ id, bitrate, name[0...40], listeners, current_title[0...50] ]
    end

    def self.header
      "%11s %3s %-40s %7s %50s" % %w(id bit station-name listen. title)
    end

    # Compare by +listeners+ and +id+
    def <=>(other)
      result = listeners <=> other.listeners
      result = id <=> other.id  if result.zero?
      result
    end
  end

  # A list of stations. Behaves like an Array.
  #
  # See Station
  class Stationlist
    include Xml
    extend Forwardable

    def_delegators :@stations, *(Array.instance_methods - instance_methods)

    # <tunein base="/sbin/tunein-station.pls"/>
    # <station... /> <station .../>
    xml_reader :tunein_base_path, :from => '@base', :in => 'tunein'
    xml_attr :stations, :as => [ Station ]

    class << self
      attr_accessor :base_uri
    end
    self.base_uri = Fetcher.base_uri

    # Returns an url ready to tune in.
    def tunein(station)
      "#{self.class.base_uri}#{tunein_base_path}?id=#{station.id}"
    end

    private

    # ROXML hook
    def after_parse # :nodoc:
      each { |station| station.tunein = tunein(station) }
    end
  end

  # A music genre.
  class Genre
    include Xml
    # <genre name="24h"/>
    xml_reader :name, :from => :attr

    # Compare by +name+
    def <=>(other)
      name <=> other.name
    end

    # String representation of this station
    def to_s
      name
    end
  end

  # A list of genres. Behaves like an Array.
  #
  # See Genre
  class Genrelist
    include Xml
    extend Forwardable

    def_delegators :@genres, *(Array.instance_methods - instance_methods)

    xml_attr :genres, :as => [ Genre ]
  end

end
