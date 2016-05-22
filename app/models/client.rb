class Client < ActiveRecord::Base
  validates :identifier, presence: true, uniqueness: true
  validates :root_url, presence: true

  has_many :payload_requests
  has_many :request_types, through: :payload_requests
  has_many :urls, through: :payload_requests
  has_many :software_agents, through: :payload_requests
  has_many :resolutions, through: :payload_requests


  # def requests_for_client
  #   PayloadRequest.where(client_id: id)
  # end

  def avg_response_time
    payload_requests.average_response_time.to_f.round(1)
  end

  def max_response_time
    payload_requests.maximum_response_time
  end

  def min_response_time
    payload_requests.minimum_response_time
  end

  def frequent_request_type
    request_types.most_frequent_request_verbs
  end

  def list_of_verbs
    request_types.all_verbs.uniq.join(", ")
  end

  def ordered_urls
    urls.group(:url).order('count_all DESC').count.keys.join(", ")
  end

  def browsers
    software_agents.all_browsers.uniq.join(", ")
  end

  def operating_systems
    software_agents.all_os.uniq.join(", ")
  end

  def screen_resolutions
    resolutions.all_widths_by_heights.uniq.join(", ")
  end

end
