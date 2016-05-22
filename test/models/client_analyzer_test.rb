require_relative "../test_helper"

class ClientAnalyzerTest < Minitest::Test
  include TestHelpers

  def test_client_defaults_are_recognized
    ca = ClientAnalyzer.new("jumpstartlab", "http://jumpstartlab.com")

    assert_equal "jumpstartlab", ca.identifier
    assert_equal "http://jumpstartlab.com", ca.root_url
    assert_equal 200, ca.status
    assert_equal "{'Identifier': 'jumpstartlab'}", ca.body
  end

  def test_can_create_or_find_client
    ca = ClientAnalyzer.new("jumpstartlab", "http://jumpstartlab.com")
    ca.create_or_find_client

    assert_equal 200, ca.status
    assert_equal "{'Identifier': 'jumpstartlab'}", ca.body
  end

  def test_if_client_wasnt_created_will_throw_errors
    ca = ClientAnalyzer.new("", "http://jumpstartlab.com")
    ca.create_or_find_client

    assert_equal 400, ca.status
    assert_equal "Identifier can't be blank", ca.body
  end

  def test_if_client_exists_throw_errors
    ca = ClientAnalyzer.new("jumpstartlab", "http://jumpstartlab.com")
    ca.create_or_find_client
    cl = ClientAnalyzer.new("jumpstartlab", "http://jumpstartlab.com")
    cl.create_or_find_client

    assert_equal 403, cl.status
    assert_equal "The client with identifier 'jumpstartlab' already exists.", cl.body
  end
end
