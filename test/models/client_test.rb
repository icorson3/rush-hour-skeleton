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

  def test_it_can_find_average_response_time_for_its_payloads
    client = Client.create({identifier: "jumpstartlab", root_url: "http://jumpstartlab.com"})
    payloads = create_payloads(3)
    payloads.each {|payload| PayloadAnalyzer.new(payload, 1)}
    assert_equal 10.0, client.avg_response_time
  end

  def test_it_can_find_the_maximum_response_time_for_its_payloads
    client = Client.create({identifier: "jumpstartlab", root_url: "http://jumpstartlab.com"})
    payloads = create_payloads(3)
    payloads.each {|payload| PayloadAnalyzer.new(payload, 1)}
    assert_equal 20.0, client.max_response_time
  end

  def test_it_can_find_min_response_time_for_its_payloads
    client = Client.create({identifier: "jumpstartlab", root_url: "http://jumpstartlab.com"})
    payloads = create_payloads(3)
    payloads.each {|payload| PayloadAnalyzer.new(payload, 1)}
    assert_equal 0.0, client.min_response_time
  end

  def test_it_can_find_its_most_frequently_resquested_class_verbs
    p1 = '{
        "url":"http://jumpstartlab.com/",
        "requestedAt":"'"#{Time.now}"'",
        "respondedIn":"10",
        "referredBy":"http://jumpstartlab.com/",
        "requestType":"GET",
        "parameters": [],
        "eventName":"socialLogin",
        "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
        "resolutionWidth":"1920",
        "resolutionHeight":"1280",
        "ip":"63.29.38.211"
        }'

    p2 = '{
        "url":"http://jumpstartlab.com/",
        "requestedAt":"'"#{Time.now}"'",
        "respondedIn":"10",
        "referredBy":"http://jumpstartlab.com/",
        "requestType":"GET",
        "parameters": [],
        "eventName":"socialLogin",
        "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
        "resolutionWidth":"1920",
        "resolutionHeight":"1280",
        "ip":"63.29.38.211"
        }'

    p3 = '{
      "url":"http://jumpstartlab.com/",
      "requestedAt":"'"#{Time.now}"'",
      "respondedIn":"10",
      "referredBy":"http://jumpstartlab.com/",
      "requestType":"POST",
      "parameters": [],
      "eventName":"socialLogin",
      "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
      "resolutionWidth":"1920",
      "resolutionHeight":"1280",
      "ip":"63.29.38.211"
      }'

    client = Client.create({identifier: "jumpstartlab", root_url: "http://jumpstartlab.com"})
    payloads = [p1, p2, p3]
    payloads.each {|payload| PayloadAnalyzer.new(payload, 1)}
    assert_equal "GET", client.frequent_request_type
  end

  def test_it_can_find_all_verbs_for_its_payloads
    p1 = '{
        "url":"http://jumpstartlab.com/",
        "requestedAt":"'"#{Time.now}"'",
        "respondedIn":"10",
        "referredBy":"http://jumpstartlab.com/",
        "requestType":"GET",
        "parameters": [],
        "eventName":"socialLogin",
        "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
        "resolutionWidth":"1920",
        "resolutionHeight":"1280",
        "ip":"63.29.38.211"
        }'

    p2 = '{
        "url":"http://jumpstartlab.com/",
        "requestedAt":"'"#{Time.now}"'",
        "respondedIn":"10",
        "referredBy":"http://jumpstartlab.com/",
        "requestType":"GET",
        "parameters": [],
        "eventName":"socialLogin",
        "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
        "resolutionWidth":"1920",
        "resolutionHeight":"1280",
        "ip":"63.29.38.211"
        }'

    p3 = '{
      "url":"http://jumpstartlab.com/",
      "requestedAt":"'"#{Time.now}"'",
      "respondedIn":"10",
      "referredBy":"http://jumpstartlab.com/",
      "requestType":"POST",
      "parameters": [],
      "eventName":"socialLogin",
      "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
      "resolutionWidth":"1920",
      "resolutionHeight":"1280",
      "ip":"63.29.38.211"
      }'
    client = Client.create({identifier: "jumpstartlab", root_url: "http://jumpstartlab.com"})
    payloads = [p1, p2, p3]
    payloads.each {|payload| PayloadAnalyzer.new(payload, 1)}
    assert_equal "GET, POST", client.list_of_verbs
  end

  def test_it_can_find_its_most_popular_urls
    p1 = '{
        "url":"http://jumpstartlab.com/",
        "requestedAt":"'"#{Time.now}"'",
        "respondedIn":"10",
        "referredBy":"http://jumpstartlab.com/",
        "requestType":"GET",
        "parameters": [],
        "eventName":"socialLogin",
        "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
        "resolutionWidth":"1920",
        "resolutionHeight":"1280",
        "ip":"63.29.38.211"
        }'

    p2 = '{
        "url":"http://google.com/",
        "requestedAt":"'"#{Time.now}"'",
        "respondedIn":"10",
        "referredBy":"http://jumpstartlab.com/",
        "requestType":"GET",
        "parameters": [],
        "eventName":"socialLogin",
        "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
        "resolutionWidth":"1920",
        "resolutionHeight":"1280",
        "ip":"63.29.38.211"
        }'

    p3 = '{
      "url":"http://jumpstartlab.com/",
      "requestedAt":"'"#{Time.now}"'",
      "respondedIn":"10",
      "referredBy":"http://jumpstartlab.com/",
      "requestType":"POST",
      "parameters": [],
      "eventName":"socialLogin",
      "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
      "resolutionWidth":"1920",
      "resolutionHeight":"1280",
      "ip":"63.29.38.211"
      }'
    client = Client.create({identifier: "jumpstartlab", root_url: "http://jumpstartlab.com"})
    payloads = [p1, p2, p3]
    payloads.each {|payload| PayloadAnalyzer.new(payload, 1)}
    assert_equal "http://jumpstartlab.com/, http://google.com/", client.ordered_urls
  end

  def test_it_can_find_all_browsers
    p1 = '{
      "url":"'"http://jumpstartlab.com/"'",
      "requestedAt":"'"#{Time.now}"'",
      "respondedIn":'"#{1 * 10}"',
      "referredBy":"'"http://jumpstartlab.com/#{1}"'",
      "requestType":"GET",
      "parameters": [],
      "eventName":"'"socialLogin#{1}"'",
      "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
      "resolutionWidth":"1920",
      "resolutionHeight":"1280",
      "ip":"'"63.29.38.21#{1}"'"
    }'

    p2 =  '{
      "url":"http://jumpstartlab.com/",
      "requestedAt":"'"#{Time.now}"'",
      "respondedIn":'"#{2 * 10}"',
      "referredBy":"'"http://jumpstartlab.com/#{2}"'",
      "requestType":"GET",
      "parameters": [],
      "eventName":"'"socialLogin#{2}"'",
      "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Safari /24.0.1309.0 Safari/537.17",
      "resolutionWidth":"1920",
      "resolutionHeight":"1280",
      "ip":"'"63.29.38.21#{2}"'"
    }'
    client = Client.create({identifier: "jumpstartlab", root_url: "http://jumpstartlab.com"})
    payloads = [p1, p2]
    payloads.each {|payload| PayloadAnalyzer.new(payload, 1)}
    assert_equal "Chrome, Safari", client.browsers
  end

  def test_it_can_find_all_operating_systems
    p1 = '{
        "url":"http://jumpstartlab.com/",
        "requestedAt":"'"#{Time.now}"'",
        "respondedIn":"10",
        "referredBy":"http://jumpstartlab.com/",
        "requestType":"GET",
        "parameters": [],
        "eventName":"socialLogin",
        "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
        "resolutionWidth":"1920",
        "resolutionHeight":"1280",
        "ip":"63.29.38.211"
        }'

    p2 = '{
        "url":"http://google.com/",
        "requestedAt":"'"#{Time.now}"'",
        "respondedIn":"10",
        "referredBy":"http://jumpstartlab.com/",
        "requestType":"GET",
        "parameters": [],
        "eventName":"socialLogin",
        "userAgent":"Mozilla/5.0 (compatible, MSIE 11, Windows NT 6.3; Trident/7.0; rv:11.0) like Gecko",
        "resolutionWidth":"1920",
        "resolutionHeight":"1280",
        "ip":"63.29.38.211"
        }'

    client = Client.create({identifier: "jumpstartlab", root_url: "http://jumpstartlab.com"})
    payloads = [p1, p2]
    payloads.each {|payload| PayloadAnalyzer.new(payload, 1)}
    assert_equal "OS X 10.8.2, Windows 8.1", client.operating_systems
  end

  def test_it_can_find_all_screen_resolutions
    p1 = '{
        "url":"http://jumpstartlab.com/",
        "requestedAt":"'"#{Time.now}"'",
        "respondedIn":"10",
        "referredBy":"http://jumpstartlab.com/",
        "requestType":"GET",
        "parameters": [],
        "eventName":"socialLogin",
        "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
        "resolutionWidth":"1920",
        "resolutionHeight":"1280",
        "ip":"63.29.38.211"
        }'

    p2 = '{
        "url":"http://google.com/",
        "requestedAt":"'"#{Time.now}"'",
        "respondedIn":"10",
        "referredBy":"http://jumpstartlab.com/",
        "requestType":"GET",
        "parameters": [],
        "eventName":"socialLogin",
        "userAgent":"Mozilla/5.0 (compatible, MSIE 11, Windows NT 6.3; Trident/7.0; rv:11.0) like Gecko",
        "resolutionWidth":"1366",
        "resolutionHeight":"768",
        "ip":"63.29.38.211"
        }'
    client = Client.create({identifier: "jumpstartlab", root_url: "http://jumpstartlab.com"})
    payloads = [p1, p2]
    payloads.each {|payload| PayloadAnalyzer.new(payload, 1)}
    assert_equal "1920x1280, 1366x768", client.screen_resolutions
  end

end
