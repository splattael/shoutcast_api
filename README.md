# Shoutcast API

Simple API for http://shoutcast.com.
Uses httparty and roxml for fetching and parsing data from http://yp.shoutcast.com/sbin/newxml.phtml.

## Usage

    require 'shoutcast_api'

    # Stations
    Shoutcast.search(:name => "Chronix").each do |station|
      p station
      puts station.tunein
    end

    Shoutcast.search(:genre => "Metal")

    # Genres
    Shoutcast.genres # => all genres

## Install

    gem install shoutcast_api

### Test

    git clone git://github.com/splattael/shoutcast_api.git
    cd shoutcast_api
    bundle

## Command line

    shoutcast_api               # List genres

    shoutcast_api name=Chronix  # Search for station "Chronix"

    # Search for station with genre "metal", bitrate 128 and media type "audio/mpeg"
    shoutcast_api genre=metal br=128 mt=audio/mpeg

## Authors

* Peter Suschlik

## TODO

* Use fakeweb for mocking http requests
* command line options transformations
