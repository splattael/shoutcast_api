require File.join(File.dirname(__FILE__), 'helper')

class FetcherTest < Test::Unit::TestCase
  include Shoutcast

  def test_base_uri
    assert_equal "http://yp.shoutcast.com", Stationlist.base_uri
  end

  def test_genres_list
    stub_http_response_with("genrelist.plain")

    list = Fetcher.genres
    # DRY test/text_xml.rb GenrelistTest
    assert_instance_of Genrelist, list
    assert_instance_of Array, list.genres
    assert_instance_of Genre, list.genres.first
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
    assert_instance_of Array, list.stations
    assert_instance_of Station, list.stations.first
  end

  def test_search_empty_response
    stub_http_response_with("empty.plain")

    assert_nil Fetcher.genres
  end

end
