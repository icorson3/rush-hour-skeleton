require_relative "../test_helper"

class ClientTest < Minitest::Test
  include TestHelpers

  def test_it_has_relationship_with_payload_request
    c = Client.new
    assert_respond_to(c, :payload_requests)
  end

end
