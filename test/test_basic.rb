require File.join(File.dirname(__FILE__), 'helper')

class ExtensionsTest < Test::Unit::TestCase

  def test_file_fixture
    assert_equal "", file_fixture("empty.plain")
  end

  def test_http_response_stubbing
    stub_http_response_with("empty.plain")

    assert_equal "", HTTParty.get('').body
  end

end

class ShoutcastTest < Test::Unit::TestCase

  def test_delegators
    assert_respond_to Shoutcast, :genres
    assert_respond_to Shoutcast, :search
  end

end
