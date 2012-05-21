require 'helper'

context Shoutcast do
  setup { Shoutcast }

  asserts("responds to genres").respond_to(:genres)
  asserts("responds to search").respond_to(:search)
end

context "Extensions" do
  asserts("empty body with empty file") { file_fixture("empty.plain") }.equals("")
  #asserts("http stubbing") do
  #  stub_http_response_with("empty.plain")
  #  HTTParty.get('').body
  #end.equals("")
end
