require_relative "../test_helper"

class ClientTest < Minitest::Test
  include TestHelpers

  def test_it_has_relationship_with_payload_request
    c = Client.new
    assert_respond_to(c, :payload_requests)
  end

  def test_validations_work
    c = Client.create({identifier: "jumpstartlab", root_url: "http://jumpstartlab.com"})
    assert c.valid?
  end

  def test_empty_identifier_string_is_invalid
    c = Client.create({identifier: "", root_url: "http://jumpstartlab.com"})
    assert c.invalid?
  end

  def test_empty_root_url_string_is_invalid
    c = Client.create({identifier: "jumpstartlab", root_url: ""})
    assert c.invalid?
  end

  def test_nil_identifier_is_invalid
    c = Client.create({identifier: nil, root_url: "http://jumpstartlab.com"})
    assert c.invalid?
  end

  def test_nil_root_url_is_invalid
    c = Client.create({identifier: "jumpstartlab", root_url: nil})
    assert c.invalid?
  end

  def test_no_info_is_invalid
    c = Client.create
    assert c.invalid?
  end
end
