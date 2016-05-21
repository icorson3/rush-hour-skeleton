require_relative "../test_helper"

class PayloadRequestTest < Minitest::Test
 include TestHelpers
  def setup
    @payload = PayloadRequest.new
  end

  def test_full_payload_request_is_valid
    skip
    payload = PayloadRequest.create({
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
         "ip" => "63.29.38.211",
         "client_id" => "2"
        })

    assert payload.valid?
  end

  # def test_missing_line_payload_request_is_invalid
  #   payload = PayloadRequest.create({
  #     "url"=> "http://jumpstartlab.com/blog",
  #     "requested_at" => "2013-02-16 21:38:28 -0700",
  #   })
  #
  #   assert payload.invalid?
  # end
  #
  # def test_empty_string_payload_request_is_invalid
  #   payload = PayloadRequest.create({
  #     "url"=> "",
  #     "requested_at" => "",
  #     "responded_in"=> "",
  #     "reference"=>"http://jumpstartlab.com",
  #     "request_type"=>"GET",
  #     "parameters"=>[],
  #     "event_name"=> "socialLogin",
  #     "user_agent"=>"Mozilla/5.0 ",
  #     "resolution_width"=>"1920",
  #     "resolution_height"=>"1280",
  #     "ip"=>"63.29.38.211"
  #   })
  #
  #   assert payload.invalid?
  # end
  #
  # def test_nil_payload_request_is_invalid
  #   payload = PayloadRequest.create({
  #     "url"=> nil,
  #     "requested_at" => nil,
  #     "responded_in"=> nil,
  #     "reference"=>"http://jumpstartlab.com",
  #     "request_type"=>"GET",
  #     "parameters"=>[],
  #     "event_name"=> "socialLogin",
  #     "user_agent"=>"Mozilla/5.0 ",
  #     "resolution_width"=>"1920",
  #     "resolution_height"=>"1280",
  #     "ip"=>"63.29.38.211"
  #   })
  #
  #   assert payload.invalid?
  # end

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
end
