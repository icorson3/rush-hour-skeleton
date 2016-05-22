require_relative '../test_helper'

class UserCanSeeClientUrlSpecificStatistics < FeatureTest

  def test_user_sees_all_client_url_statistics
    client = Client.create({identifier: "jumpstartlab", root_url: "http://jumpstartlab.com"})

    payloads = create_payloads_with_same_url(3)
    payloads.each {|payload| PayloadAnalyzer.new(payload, 1)}

    visit '/sources/jumpstartlab/urls/blog'

    assert page.has_content?("Statistics for URL")
    assert page.has_content?("Response Time Data")
    assert page.has_content?("Maximum:")
    assert page.has_content?("Minimum:")
    assert page.has_content?("All Times:")
    assert page.has_content?("Average:")
    assert page.has_content?("Other Data")
    assert page.has_content?("Associated HTTP verbs:")
    assert page.has_content?("Most Popular Referrers:")
    assert page.has_content?("Top User Agents:")
  end

  def test_it_errors_if_no_data_provided
    client = Client.create({identifier: "jumpstartlab", root_url: "http://jumpstartlab.com"})

    visit '/sources/jumpstartlab/urls/blog'

    assert page.has_content? "No data has been provided for this client"
  end
end
