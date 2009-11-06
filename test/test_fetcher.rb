require File.join(File.dirname(__FILE__), 'helper')

require 'ostruct'
class FakeResponse < OpenStruct
  def initialize(&block)
    super
    block.call(self) if block
  end

  def empty?
    false
  end

  def body
    self
  end
end

class FetcherTest < Test::Unit::TestCase
  include Shoutcast

  def test_base_uri
    assert_equal "http://yp.shoutcast.com", Stationlist.base_uri
  end

  def test_nocache_paramater
    fetcher = Fetcher.clone

    def fetcher.get(path, options)
      FakeResponse.new do |response|
        response.options = options
      end
    end

    # {}
    response = fetcher.send(:fetch) { |response| response }
    assert response
    assert_instance_of Hash, response.options
    assert_instance_of Hash, response.options[:query]
    assert response.options[:query][:nocache]

    # { :nocache => "random" }
    response = fetcher.send(:fetch, :nocache => "random") { |response| response }
    assert response
    assert_instance_of Hash, response.options
    assert_instance_of Hash, response.options[:query]
    assert_equal "random", response.options[:query][:nocache]

    # nil
    response = fetcher.send(:fetch, nil) { |response| response }
    assert_instance_of Hash, response.options
    assert_instance_of Hash, response.options[:query]
    assert response.options[:query][:nocache]
  end

  def test_genres_list
    stub_http_response_with("genrelist.plain")

    list = Fetcher.genres
    # DRY test/text_xml.rb GenrelistTest
    assert_instance_of Genrelist, list
    assert_instance_of Genre, list.first
  end

  def test_genres_empty_response
    stub_http_response_with("empty.plain")

    assert_nil Fetcher.genres
  end

  def test_search_with_invalid_option
    stub_http_response_with("search_death.plain")

    list = Fetcher.search
    # DRY test/text_xml.rb StationlistTest
    assert_instance_of Stationlist, list
    assert_equal "/sbin/tunein-station.pls", list.tunein_base_path
    assert_instance_of Station, list.first
  end

  def test_search_empty_response
    stub_http_response_with("empty.plain")

    assert_nil Fetcher.genres
  end

end
