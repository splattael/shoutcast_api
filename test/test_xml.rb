require 'helper'

include Shoutcast

context Station do
  setup do
    Station.from_xml <<-XML
    <station
      id="1234"
      name=" Metal radio "
      mt="audio/mpeg"
      br="128"
      genre=" Metal Rock "
      ct=" Heavy Metal Band "
      lc="123"/>
    XML
  end

  asserts_topic("class type").kind_of(Station)
  asserts("id") { topic.id }.equals(1234)
  asserts("name") { topic.name }.equals("Metal radio")
  asserts("media type") { topic.media_type }.equals("audio/mpeg")
  asserts("bitrate") { topic.bitrate }.equals(128)
  asserts("genre") { topic.genre }.equals("Metal Rock")
  asserts("current title") { topic.current_title }.equals("Heavy Metal Band")
  asserts("listeners") { topic.listeners }.equals(123)
  asserts("no tunein path") { topic.tunein }.nil

  context "with media type" do
    setup do
      def topic.media_type
        "strange format"
      end
      topic
    end
    asserts("type") { topic.type }.equals("strange format")
  end

  context "with to_s" do
    [ :id, :name, :current_title, :bitrate, :listeners ].each do |attr|
      asserts("contains #{attr}") { topic.to_s.include?(topic.send(attr).to_s) }
    end
  end

  context "with header" do
    setup { topic.class.header }

    %w(id station-name title bit listen.).each do |header|
      asserts("contains #{header}") { topic.include?(header) }
    end
  end

  # TODO test <=>
end

context Stationlist do
  setup { Stationlist.from_xml file_fixture("search_death.plain") }

  asserts("base uri") { topic.class.base_uri }.equals("http://yp.shoutcast.com")
  asserts_topic("correct class type").kind_of(Stationlist)
  asserts("tunein path") { topic.tunein_base_path }.equals("/sbin/tunein-station.pls")
  asserts("list size") { topic.size }.equals(49)
  asserts("tunein path") { topic.tunein(topic.first) }.equals { topic.first.tunein }

  context "for first item" do
    setup { topic.first }
    asserts_topic("correct class type").kind_of(Station)
    asserts("tunein path") do
      topic.tunein
    end.equals { "http://yp.shoutcast.com/sbin/tunein-station.pls?id=#{topic.id}" }
  end
end

context Genrelist do
  setup { Genrelist.from_xml file_fixture("genrelist.plain") }

  asserts_topic("correct class type").kind_of(Genrelist)
  asserts("list size") { topic.size }.equals(434)
  asserts("first item is Genre") { topic.first }.kind_of(Genre)
  asserts_topic("responds to each").respond_to(:each)
  asserts("raises NoMethodError on invalid method") { topic.invalid_method }.raises(NoMethodError)
  asserts("gernes name == to_s") { topic.first.name }.equals { topic.first.to_s }

  context "sorted" do
    setup { topic.sort }

    asserts("first genre name") { topic.first.name }.equals("24h")
    asserts("last genre name") { topic.last.name }.equals("Zouk")
  end
end

context Xml do
  setup do
    Class.new do
      include Xml
    end
  end

  asserts_topic("responds to trim").respond_to(:trim)
  asserts("trims strings") { topic.trim.call(" trim me ") }.equals("trim me")
end
