require_relative '../test_helper'
require 'pry'

class RushHourAppTest < Minitest::Test
  include TestHelpers

  def test_it_can_create_new_instance_of_client
    assert_equal 0, Client.count
    post '/sources',  {identifier: "jumpstartlab", rootUrl: "http://jumpstartlab.com"}
    assert_equal 1, Client.count
    assert_equal 200, last_response.status
    assert_equal "{'Identifier': 'jumpstartlab'}", last_response.body
  end

  def test_it_can_send_error_if_client_is_not_unique
    post '/sources',  {identifier: "jumpstartlab", rootUrl: "http://jumpstartlab.com"}
    assert_equal 1, Client.count
    assert_equal 200, last_response.status
    assert_equal "{'Identifier': 'jumpstartlab'}", last_response.body

    post '/sources',  {identifier: "jumpstartlab", rootUrl: "http://jumpstartlab.com"}
    assert_equal 1, Client.count
    assert_equal 403, last_response.status
    assert_equal "The client with identifier 'jumpstartlab' already exists.", last_response.body

  end

  def test_it_can_send_error_if_client_identifier_is_missing
    post '/sources',  {rootUrl: "http://jumpstartlab.com"}
    assert_equal 0, Client.count
    assert_equal 400, last_response.status
    assert_equal "Identifier can't be blank", last_response.body
  end

  def test_it_can_send_error_if_client_root_url_is_missing
    post '/sources',  {identifier: "jumpstartlab"}
    assert_equal 0, Client.count
    assert_equal 400, last_response.status
    assert_equal "Root url can't be blank", last_response.body
  end

  def test_it_can_send_a_unique_payload_request
    raw_payload =
    'payload={
      "url":"http://jumpstartlab.com/blog",
      "requestedAt":"2013-02-16 21:38:28 -0700",
      "respondedIn":37,"referredBy":"http://jumpstartlab.com",
      "requestType":"GET",
      "parameters":[],"eventName":"socialLogin",
      "userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
      "resolutionWidth":"1920",
      "resolutionHeight":"1280",
      "ip":"63.29.38.211"}'
    assert_equal 0, Client.count
    assert_equal 0, PayloadRequest.count
    Client.create({identifier: "jumpstartlab", root_url: "http://jumpstartlab.com"})
    assert_equal 1, Client.count
    post '/sources/jumpstartlab/data', raw_payload
    assert_equal 200, last_response.status
    assert_equal "Payload created successfully", last_response.body
  end

  def test_it_sends_error_if_request_is_sent_without_payload
    Client.create({identifier: "jumpstartlab", root_url: "http://jumpstartlab.com"})
    post '/sources/jumpstartlab/data'
    assert_equal 400, last_response.status
    assert_equal 0, PayloadRequest.count
    assert_equal "Please send payload parameters with request.", last_response.body
  end

  def test_it_sends_error_if_the_payload_request_has_already_been_received
    raw_payload =
    'payload={
      "url":"http://jumpstartlab.com/blog",
      "requestedAt":"2013-02-16 21:38:28 -0700",
      "respondedIn":37,"referredBy":"http://jumpstartlab.com",
      "requestType":"GET",
      "parameters":[],"eventName":"socialLogin",
      "userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
      "resolutionWidth":"1920",
      "resolutionHeight":"1280",
      "ip":"63.29.38.211"}'

    Client.create({identifier: "jumpstartlab", root_url: "http://jumpstartlab.com"})

    2.times {post '/sources/jumpstartlab/data', raw_payload}
    assert_equal 403, last_response.status
    assert_equal "Payload Request must be unique.", last_response.body
  end

  def test_it_cant_accept_payload_from_an_unregistered_client
    raw_payload =
    'payload={
      "url":"http://jumpstartlab.com/blog",
      "requestedAt":"2013-02-16 21:38:28 -0700",
      "respondedIn":37,"referredBy":"http://jumpstartlab.com",
      "requestType":"GET",
      "parameters":[],"eventName":"socialLogin",
      "userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
      "resolutionWidth":"1920",
      "resolutionHeight":"1280",
      "ip":"63.29.38.211"}'
    post '/sources/jumpstartlab/data', raw_payload
    assert_equal 0, Client.count
    assert_equal 403, last_response.status
    assert_equal "The client jumpstartlab has not been registered with the application.", last_response.body
  end

  def test_it_works_if_client_and_client_data_both_exist
    assert_equal 0, Client.count
    assert_equal 0, PayloadRequest.count

    payloads = create_payloads(3)

    Client.create({identifier: "jumpstartlab", root_url: "http://jumpstartlab.com"})
    assert_equal 1, Client.count

    payloads.each {|payload| PayloadAnalyzer.new(payload, 1)}
    assert_equal 3, PayloadRequest.count

    get '/sources/jumpstartlab'
    assert_equal 200, last_response.status
    assert_equal "Success", last_response.body
  end

  def test_it_will_return_error_if_client_does_not_exist
    assert_equal 0, Client.count
    assert_equal 0, PayloadRequest.count

    payloads = create_payloads(3)

    payloads.each {|payload| PayloadAnalyzer.new(payload, 1)}
    assert_equal 3, PayloadRequest.count

    get '/sources/jumpstartlab'
    assert_equal 403, last_response.status
    assert_equal "The Client with identifier 'jumpstartlab' doesn't exist", last_response.body
  end

  def test_it_will_return_error_if_client_data_does_not_exist
    assert_equal 0, Client.count
    assert_equal 0, PayloadRequest.count

    Client.create({identifier: "jumpstartlab", root_url: "http://jumpstartlab.com"})
    assert_equal 1, Client.count

    get '/sources/jumpstartlab'
    assert_equal 403, last_response.status
    assert_equal "No data has been provided for this client", last_response.body
  end
end
