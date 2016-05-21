require_relative '../test_helper'

class PayloadAnalyzerTest < Minitest::Test
  include TestHelpers
  def setup
    @payload =
    '{
     "url":"http://jumpstartlab.com/blog",
     "requestedAt":"2013-02-16 21:38:28 -0700",
     "respondedIn":37,
     "referredBy":"http://jumpstartlab.com",
     "requestType":"GET",
     "parameters":[],
     "eventName": "socialLogin",
     "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
     "resolutionWidth":"1920",
     "resolutionHeight":"1280",
     "ip":"63.29.38.211"
    }'
  end

  def test_it_can_parse_from_JSON_to_a_hash
    input =
    '{
     "url":"http://jumpstartlab.com/blog",
     "requestedAt":"2013-02-16 21:38:28 -0700",
     "respondedIn":37,
     "referredBy":"http://jumpstartlab.com",
     "requestType":"GET",
     "parameters":[],
     "eventName": "socialLogin",
     "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
     "resolutionWidth":"1920",
     "resolutionHeight":"1280",
     "ip":"63.29.38.211"
    }'

    payload =
    {
     "url" => "http://jumpstartlab.com/blog",
     "requestedAt" => "2013-02-16 21:38:28 -0700",
     "respondedIn" => 37,
     "referredBy" => "http://jumpstartlab.com",
     "requestType" => "GET",
     "parameters" => [],
     "eventName" =>  "socialLogin",
     "userAgent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
     "resolutionWidth" => "1920",
     "resolutionHeight" => "1280",
     "ip" => "63.29.38.211"
    }
    pp = PayloadAnalyzer.new(input, 1)

    assert_equal payload, pp.payload
  end

  def test_it_can_populate_the_urls_table
    pp = PayloadAnalyzer.new(@payload, 1)

    urls = pp.populate_urls
    assert_equal "http://jumpstartlab.com/blog", urls.url
  end

  def test_it_can_populate_the_references_table
    pp = PayloadAnalyzer.new(@payload, 1)
    references = pp.populate_references
    assert_equal "http://jumpstartlab.com", references.reference
  end

  def test_it_can_populate_request_types_table
    pp = PayloadAnalyzer.new(@payload, 1)
    request = pp.populate_request_types
    assert_equal "GET", request.request_type
  end

  def test_it_can_populate_the_event_name_table
    pp = PayloadAnalyzer.new(@payload, 1)
    event_names = pp.populate_event_names
    assert_equal "socialLogin", event_names.event_name
  end

  def test_it_can_populate_user_agents_table
    pp = PayloadAnalyzer.new(@payload, 1)
    agents = pp.populate_software_agents
    assert_equal "Chrome", agents.browser
    assert_equal "OS X 10.8.2", agents.os
  end

  def test_it_can_populate_the_resolutions_table
    pp = PayloadAnalyzer.new(@payload, 1)
    resolutions = pp.populate_resolutions
    assert_equal "1920", resolutions.resolution_width
    assert_equal "1280", resolutions.resolution_height
  end

  def test_it_can_populate_ip_addresses_table
    pp = PayloadAnalyzer.new(@payload, 1)
    ips = pp.populate_ip_addresses
    assert_equal "63.29.38.211", ips.ip_address
  end

  def test_it_can_populate_all_the_tables
    payloads = create_payloads(2)
    payloads.each do |payload|
      PayloadAnalyzer.new(payload, 1)
    end
    assert_equal 2, PayloadRequest.count
  end

  def test_cant_populate_tables_if_payload_request_missing_information
    bad_payload = '{"ip":"63.29.38.211"}'
    pa = PayloadAnalyzer.new(bad_payload, 1)
    assert_equal 400, pa.status
    assert pa.body.include?("can't be blank")
  end

  def test_it_gives_error_if_the_payload_is_missing
    pa = PayloadAnalyzer.new(nil, 1)
    assert_equal 400, pa.status
    assert_equal "Please send payload parameters with request.", pa.body
  end

  def test_it_gives_error_if_the_payload_has_already_been_received
    successfull = PayloadAnalyzer.new(@payload, 1)
    assert_equal 1, PayloadRequest.count
    assert_equal 200, successfull.status
    assert_equal "Payload created successfully", successfull.body

    unsuccessful = PayloadAnalyzer.new(@payload, 1)
    assert_equal 403, unsuccessful.status
    assert_equal "Payload Request must be unique.", unsuccessful.body
  end


end
