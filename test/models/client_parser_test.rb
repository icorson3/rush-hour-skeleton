require_relative '../test_helper'

class ClientParserTest < Minitest::Test
  include TestHelpers
  include ClientParser

  def test_it_can_parse_the_raw_parameters
    raw_params = 'identifier=jumpstartlab&rootUrl=http://jumpstartlab.com'
    params = {identifier: "jumpstartlab",
              root_url:   "http://jumpstartlab.com"}
    assert_equal params, parse_client_data(raw_params)
  end
end
