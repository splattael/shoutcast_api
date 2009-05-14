require File.join(File.dirname(__FILE__), 'helper')

class StationTest < Test::Unit::TestCase
  include Shoutcast

  def setup
    xml = <<-XML
      <station
        id="1234"
        name=" Metal radio "
        mt="audio/mpeg"
        br="128"
        genre=" Metal Rock "
        ct=" Heavy Metal Band "
        lc="123"/>
      XML

    @station = Station.from_xml xml
  end

  def test_parsing
    assert_instance_of Station, @station
    assert_equal 1234, @station.id
    assert_equal "Metal radio", @station.name
    assert_equal "audio/mpeg", @station.media_type
    assert_equal 128, @station.bitrate
    assert_equal "Metal Rock", @station.genre
    assert_equal "Heavy Metal Band", @station.current_title
    assert_equal 123, @station.listeners
    assert_nil @station.tunein
  end

  def test_type
    assert_equal "mpeg", @station.type

    def @station.media_type
      "strange format"
    end

    assert_equal "strange format", @station.type
  end

  def test_to_s
    string = @station.to_s

    assert string.include?(@station.id.to_s)
    assert string.include?(@station.name)
    assert string.include?(@station.current_title)
    assert string.include?(@station.bitrate.to_s)
    assert string.include?(@station.listeners.to_s)
  end

  def test_header
    string = Station.header

    assert string.include?("id")
    assert string.include?("station-name")
    assert string.include?("title")
    assert string.include?("bit")
    assert string.include?("listen.")
  end

  # TODO test <=>

end


class StationlistTest < Test::Unit::TestCase
  include Shoutcast

  def setup
    @list = Stationlist.from_xml file_fixture("search_death.plain")
  end

  def test_attributes
    assert_instance_of Stationlist, @list
    assert_equal "/sbin/tunein-station.pls", @list.tunein_base_path
    assert_instance_of Array, @list.stations
    assert_equal 49, @list.stations.size
    assert_instance_of Station, @list.stations.first
  end

  def test_base_uri
    assert_equal "http://yp.shoutcast.com", Stationlist.base_uri
  end

  def test_tunein
    station = @list.stations.first

    assert_equal "http://yp.shoutcast.com/sbin/tunein-station.pls?id=#{station.id}", @list.tunein(station)
  end

  def test_tunein_propagtion_after_parse
    station = @list.stations.first

    assert_equal @list.tunein(station), station.tunein
  end

end


class GenrelistTest < Test::Unit::TestCase
  include Shoutcast

  def setup
    @list = Genrelist.from_xml file_fixture("genrelist.plain")
  end

  def test_parsing
    assert_instance_of Genrelist, @list
    assert_instance_of Array, @list.genres
    assert_equal 434, @list.genres.size
    assert_instance_of Genre, @list.genres.first
  end

  def test_genre_name
    sorted = @list.genres.sort

    assert_equal "24h", sorted.first.name
    assert_equal "Zouk", sorted.last.name
  end

end


class DataTest < Test::Unit::TestCase
  include Shoutcast

  def test_trim
    assert_respond_to Data, :trim

    string = "  test mee   "
    assert_equal "test mee", Data.trim.call(string)
  end

end
