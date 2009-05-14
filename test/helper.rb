$LOAD_PATH.unshift File.join(File.dirname(__FILE__), "..", "lib")

require 'rubygems'
require 'test/unit'
require 'mocha'

require 'shoutcast_api'

module TestExtensions
  def file_fixture(filename)
    File.read(File.join(File.dirname(__FILE__), 'fixtures', filename.to_s))
  end

  def stub_http_response_with(filename)
    format = filename.split('.').last.intern
    data = file_fixture(filename)

    response = Net::HTTPOK.new("1.1", 200, "Content for you")
    response.stubs(:body).returns(data)

    http_request = HTTParty::Request.new(Net::HTTP::Get, 'http://localhost', :format => format)
    http_request.stubs(:perform_actual_request).returns(response)

    HTTParty::Request.expects(:new).returns(http_request)
  end
end

Test::Unit::TestCase.send(:include, TestExtensions)
