require 'helper'

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

include Shoutcast

context Fetcher do

  setup { Fetcher }

  asserts("base uri") { topic.base_uri }.equals("http://yp.shoutcast.com")

  context "testing nocache parameter" do
    setup do
      fetcher = Fetcher.clone

      def fetcher.get(path, options)
        FakeResponse.new do |response|
          response.options = options
        end
      end
      fetcher
    end

    asserts("random nocache parameter") do
      topic.send(:fetch) {|r| r }.options[:query][:nocache]
    end.exists

    asserts("random nocache parameter passing nil") do
      topic.send(:fetch, nil) {|r| r }.options[:query][:nocache]
    end.exists

    asserts("static nocache parameter") do
      topic.send(:fetch, :nocache => "static") {|r| r }.options[:query][:nocache]
    end.equals("static")

  end

  # TODO enable mocked tests again!
  if false
  context "fetching genres" do
    setup do
      p "here"
      stub_http_response_with("genrelist.plain")
      Fetcher.genres
    end

    asserts("class type").kind_of(Genrelist)
    asserts("first item is a Genre") { topic.first }.kind_of(Genre)
  end

  context "fetching empty genres" do
    setup do
      stub_http_response_with("empty.plain")
      Fetcher.genres
    end

    asserts("nil") { topic }.nil
  end

  context "search with invalid options" do
    setup do
      stub_http_response_with("search_death.plain")
      Fetcher.search
    end

    asserts("class type").kind_of(Stationlist)
    asserts("tunein base path") { topic.tunein_base_path }.equals("/sbin/tunein-station.pls")
    asserts("first item is a Station") { topic.first }.kind_of(Station)
  end
  
  context "searching with empty response" do
    setup do
      stub_http_response_with("empty.plain")
      Fetcher.search
    end

    asserts_topic.nil
  end
  end

end
