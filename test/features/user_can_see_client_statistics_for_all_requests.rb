require_relative '../test_helper'

class UserCanSeeClientStatisticsForAllRequests < FeatureTest

  def test_user_sees_all_client_statistics
    client = Client.create({identifier: "jumpstartlab", root_url: "http://jumpstartlab.com"})

    payloads = create_payloads(3)
    payloads.each {|payload| PayloadAnalyzer.new(payload, 1)}

    visit '/sources/jumpstartlab'

    assert page.has_content?("Welcome to your dashboard")
    assert page.has_content?("Data Across All Requests")
    assert page.has_content?("Average Response Time:")
    assert page.has_content?("Maximum Response Time:")
    assert page.has_content?("Minimum Response Time:")
    assert page.has_content?("Most Frequent Request Type:")
    assert page.has_content?("All HTTP Verbs Used:")
    assert page.has_content?("URLs from Most to Least Requested:")
    assert page.has_content?("User Machine Information")
    assert page.has_content?("Breakdown Across All Requests")
    assert page.has_content?("Web Browswers:")
    assert page.has_content?("Operating Systems:")
    assert page.has_content?("Screen Resolutions:")
  end

  def test_it_errors_if_no_data_provided
    client = Client.create({identifier: "jumpstartlab", root_url: "http://jumpstartlab.com"})

    visit '/sources/jumpstartlab'

    assert page.has_content? "No data has been provided for this client"
  end
end
