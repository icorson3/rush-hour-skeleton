class Client < ActiveRecord::Base
  validates :identifier, presence: true, uniqueness: true
  validates :root_url, presence: true

  has_many :payload_requests
  has_many :request_types, through: :payload_requests
  has_many :urls, through: :payload_requests
  has_many :software_agents, through: :payload_requests
  has_many :resolutions, through: :payload_requests


  def avg_response_time
    PayloadRequest.average_response_time.to_f.round(1)
  end

  def max_response_time
    PayloadRequest.maximum_response_time
  end

  def min_response_time
    PayloadRequest.minimum_response_time
  end

  def frequent_request_type
    RequestType.most_frequent_request_verbs
  end

  def list_of_verbs
    RequestType.all_verbs.join(", ")
  end

  def ordered_urls
    Url.most_to_least_requested_urls.join(", ")
  end

  def browsers
    SoftwareAgent.all_browsers.join(", ")
  end

  def operating_systems
    SoftwareAgent.all_os.join(", ")
  end

  def screen_resolutions
    Resolution.all_widths_by_heights.join(", ")
  end

end
