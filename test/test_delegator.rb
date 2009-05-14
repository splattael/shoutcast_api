require File.join(File.dirname(__FILE__), 'helper')

class ArrayMimic
  include Shoutcast::Delegator

  delegate_all :@array, Array

  def initialize
    @array = []
  end

end

class DelegatorTest < Test::Unit::TestCase

  def test_method_delegation
    ary = ArrayMimic.new
    ary.push 1, 2, 3

    assert_equal 3, ary.size
    assert_equal 1, ary.first
    assert_equal 3, ary.last
    assert_respond_to ary, :each
    assert_equal [].methods.sort, ary.methods.sort
  end

end
