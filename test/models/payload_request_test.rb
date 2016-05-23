require_relative "../test_helper"

class PayloadRequestTest < Minitest::Test
 include TestHelpers
  def setup
    @payload = PayloadRequest.new
  end

  def test_full_payload_request_is_valid
    payload = PayloadRequest.create({
         "url_id" => 1,
         "requested_at" => "2013-02-16 21:38:28 -0700",
         "responded_in" => 37,
         "reference_id" => 1,
         "request_type_id" => 1,
         "parameters" => [],
         "event_name_id" =>  1,
         "software_agent_id" => 1,
         "resolution_id" => 1,
         "ip_address_id" => 1,
         "client_id" => 1
        })

    assert payload.valid?
  end

  def test_missing_line_payload_request_is_invalid
    payload = PayloadRequest.create({
      "url_id"=> 1,
      "requested_at" => "2013-02-16 21:38:28 -0700",
    })

    assert payload.invalid?
  end

  def test_empty_string_payload_request_is_invalid
    payload = PayloadRequest.create({
         "url_id" => 1,
         "requested_at" => "",
         "responded_in" => 37,
         "reference_id" => 1,
         "request_type_id" => 1,
         "parameters" => [],
         "event_name_id" =>  1,
         "software_agent_id" => 1,
         "resolution_id" => 1,
         "ip_address_id" => 1,
         "client_id" => 1
        })

    assert payload.invalid?
  end

  def test_nil_payload_request_is_invalid
    payload = PayloadRequest.create({
         "url_id" => nil,
         "requested_at" => "2013-02-16 21:38:28 -0700",
         "responded_in" => 37,
         "reference_id" => nil,
         "request_type_id" => nil,
         "parameters" => [],
         "event_name_id" =>  1,
         "software_agent_id" => 1,
         "resolution_id" => 1,
         "ip_address_id" => 1,
         "client_id" => 1
        })

    assert payload.invalid?
  end

  def test_it_has_relationship_with_url
    assert_respond_to(@payload, :url)
  end

  def test_it_has_relationship_with_reference
    assert_respond_to(@payload, :reference)
  end

  def test_it_has_relationship_with_request_type
    assert_respond_to(@payload, :request_type)
  end

  def test_it_has_relationship_with_event_name
    assert_respond_to(@payload, :event_name)
  end

  def test_it_has_relationship_with_software_agents
    assert_respond_to(@payload, :software_agent)
  end

  def test_it_has_relationship_with_resolution
    assert_respond_to(@payload, :resolution)
  end

  def test_it_has_relationship_with_ip_address
    assert_respond_to(@payload, :ip_address)
  end

  def test_it_has_relationship_with_client
    assert_respond_to(@payload, :client)
  end

  def test_it_can_create_n_number_raw_payloads
    assert_equal 3, create_payloads(3).count
  end

  def test_it_can_find_the_average_response_time
    payloads = create_payloads(3)

    Client.create({identifier: "jumpstartlab", root_url: "http://jumpstartlab.com"})
    payloads.each {|payload| PayloadAnalyzer.new(payload, 1)}

    assert_equal 10, PayloadRequest.average_response_time
  end

  def test_it_can_find_the_maximum_response_time
    payloads = create_payloads(3)

    Client.create({identifier: "jumpstartlab", root_url: "http://jumpstartlab.com"})
    payloads.each {|payload| PayloadAnalyzer.new(payload, 1)}

    assert_equal 20, PayloadRequest.maximum_response_time
  end

  def test_it_can_find_the_minimum_response_time
    payloads = create_payloads(3)

    Client.create({identifier: "jumpstartlab", root_url: "http://jumpstartlab.com"})
    payloads.each {|payload| PayloadAnalyzer.new(payload, 1)}

    assert_equal 0, PayloadRequest.minimum_response_time
  end

  def test_it_can_format_arrays
    times = [21, 20]
    assert_equal 1, PayloadRequest.formatted_arrays(times)[-3]
  end
  
  def test_it_can_find_hour_requested_at
    payload_1 = PayloadRequest.create({
         "url_id" => 1,
         "requested_at" => "2013-02-16 21:38:28 -0700",
         "responded_in" => 37,
         "reference_id" => 1,
         "request_type_id" => 1,
         "parameters" => [],
         "event_name_id" =>  1,
         "software_agent_id" => 1,
         "resolution_id" => 1,
         "ip_address_id" => 1,
         "client_id" => 1
        })
    payload_2 = PayloadRequest.create({
         "url_id" => 2,
         "requested_at" => "2013-02-16 20:38:28 -0700",
         "responded_in" => 37,
         "reference_id" => 2,
         "request_type_id" => 2,
         "parameters" => [],
         "event_name_id" =>  2,
         "software_agent_id" => 2,
         "resolution_id" => 2,
         "ip_address_id" => 2,
         "client_id" => 2
        })
    payloads = [payload_1, payload_2]

    assert_equal 1, PayloadRequest.find_hour_requested_at(payloads)[3]
  end

end
