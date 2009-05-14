require 'httparty'
require 'roxml'
require 'forwardable'

module Shoutcast
  extend Forwardable
  extend self

  def_delegators :Fetcher, :genres, :search

  class Fetcher
    include HTTParty
    base_uri "http://yp.shoutcast.com"
    format :plain

    def self.genres
      fetch do |xml|
        Genrelist.from_xml xml
      end
    end

    def self.search(options={})
      fetch(options) do |xml|
        Stationlist.from_xml xml
      end
    end

    private

    def self.fetch(options={}, &block)
      options.update(:nocache => Time.now.to_f)  if options
      data = get("/sbin/newxml.phtml", :query => options).body

      block.call(data)  unless data.empty?
    end
  end

  # XML

  class Data
    include ROXML

    def self.trim
      proc { |v| v.to_s.strip.squeeze(" ") }
    end
  end

  class Station < Data
    # <station
    #   id="423873"
    #   name="www.deathmetal.at"
    #   mt="audio/mpeg"
    #   br="128"
    #   genre="METAL"
    #   ct="TITLE"
    #   lc="24"/>
    attr_accessor :tunein

    xml_reader :id,             :from => :attr, :as => Integer
    xml_reader :name,           :from => :attr, &trim
    xml_reader :media_type,     :from => '@mt'
    xml_reader :bitrate,        :from => '@br', :as => Integer
    xml_reader :genre,          :from => :attr, &trim
    xml_reader :current_title,  :from => '@ct', &trim
    xml_reader :listeners,      :from => '@lc', :as => Integer

    def type
      media_type.split('/').last || media_type
    end

    def to_s
      "#%10d %3d %40s %7d %50s" % [ id, bitrate, name[0...40], listeners, current_title[0...50] ]
    end

    def self.header
      "%11s %3s %-40s %7s %50s" % %w(id bit station-name listen. title)
    end

    def <=>(other)
      result = listeners <=> other.listeners
      result = id <=> other.id  if result.zero?
      result
    end
  end

  class Stationlist < Data
    # <tunein base="/sbin/tunein-station.pls"/>
    # <station... /> <station .../>

    xml_reader :tunein_base_path, :from => '@base', :in => 'tunein'
    xml_reader :stations, :as => [ Station ]

    class << self
      attr_accessor :base_uri
    end
    self.base_uri = Fetcher.base_uri

    def tunein(station)
      "#{self.class.base_uri}#{tunein_base_path}?id=#{station.id}"
    end

    private

    def after_parse
      stations.each { |station| station.tunein = tunein(station) }
    end
  end

  class Genre < Data
    # <genre name="24h"/>
    xml_reader :name, :from => :attr

    def <=>(other)
      name <=> other.name
    end
  end

  class Genrelist < Data
    xml_reader :genres, :as => [ Genre ]
  end

end
