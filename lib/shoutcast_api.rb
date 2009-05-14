require 'httparty'
require 'roxml'
require 'forwardable'

module Shoutcast
  extend Forwardable
  extend self

  def_delegators :Fetcher, :genres, :search

  class Fetcher
    include HTTParty
    base_uri 'http://yp.shoutcast.com/sbin/newxml.phtml'
    format :plain

    def self.genres(filter=nil)
      list = Genrelist.from_xml fetch

      list.filter(filter)
    end

    def self.search(options={})
      Stationlist.from_xml fetch(options)
    end

    private

    def self.fetch(options={})
      options.update(:nocache => Time.now.to_f)
      get('', :query => options).body
    end
  end

  # XML

  class Base
    include ROXML

    def self.trim
      proc { |v| v.to_s.strip }
    end
  end

  class Station < Base
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

  class Stationlist < Base
    # <tunein base="/sbin/tunein-station.pls"/>
    # <station... /> <station .../>
    BASE_URL = "http://yp.shoutcast.com"

    xml_reader :tunein_base_path, :from => '@base', :in => 'tunein'
    xml_reader :stations, :as => [ Station ]

    def tunein(station)
      "#{BASE_URL}#{tunein_base_path}?id=#{station.id}"
    end

    private

    def after_parse
      stations.each { |station| station.tunein = tunein(station) }
    end
  end

  class Genre < Base
    # <genre name="24h"/>
    xml_reader :name, :from => :attr

    def <=>(other)
      name <=> other.name
    end
  end

  class Genrelist < Base
    xml_reader :genres, :as => [ Genre ]

    def filter(option=nil)
      case option
      when String
        genres.select { |genre| genre.name == option }
      when Regexp
        genres.select { |genre| genre.name =~ option }
      else
        genres
      end
    end
  end

end

if $0 == __FILE__
  require 'pp'

  if ARGV.size > 0
    options = ARGV.inject({}) do |hash, arg|
      key, value = arg.split(/=/)
      hash[key.intern] = value
      hash
    end
    # TODO do more transformations
    # br -> bitrate
    # ct -> current_title
    # can ROXML help us?
    options[:search] = options.delete(:name) if options[:name]

    puts Shoutcast::Station.header
    Shoutcast.search(options).stations.sort.reverse.each do |station|
      puts station
    end
  else
    pp Shoutcast.genres
  end

end
