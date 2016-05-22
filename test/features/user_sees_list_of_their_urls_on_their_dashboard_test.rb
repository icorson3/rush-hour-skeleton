require_relative "../test_helper"

class UserSeesListOfTheirURLsOnDeshboardTest < FeatureTest
  include TestHelpers

  def setup
    Client.create({identifier: "jumpstartlab", root_url: "http://jumpstartlab.com"})
    p1 = '{
        "url":"http://jumpstartlab.com/good",
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
        "url":"http://jumpstartlab.com/party",
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
    payloads = [p1, p2]
    payloads.each {|payload| PayloadAnalyzer.new(payload, 1)}
  end

  def test_user_sees_and_can_click_all_links
    visit 'sources/jumpstartlab'
    assert page.has_content?("http://jumpstartlab.com/good")
    assert page.has_content?("http://jumpstartlab.com/party")

    click_link "http://jumpstartlab.com/good"
    assert_equal '/sources/jumpstartlab/urls/good', current_path

    visit 'sources/jumpstartlab'
    save_and_open_page
    click_link "http://jumpstartlab.com/party"
    assert_equal '/sources/jumpstartlab/urls/party', current_path
  end

  # def test_user_sees_and_can_click_second_url
  #   visit 'sources/jumpstartlab'
  #   save_and_open_page
  #   assert page.has_content?("http://jumpstartlab.com/party")
  #
  #   click_link "http://jumpstartlab.com/party"
  #   assert_equal '/sources/jumpstartlab/urls/party', current_path
  # end

end
