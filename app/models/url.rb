class Url < ActiveRecord::Base
  validates :url, presence: true

  has_many :payload_requests
  has_many :request_types, through: :payload_requests
  has_many :references, through: :payload_requests
  has_many :software_agents, through: :payload_requests
  has_many :clients, through: :payload_requests

  def self.most_to_least_requested_urls
    group(:url).order('count_all DESC').count.keys
  end

  def max_response_time
    payload_requests.maximum(:responded_in)
  end

  def min_response_time
    payload_requests.minimum(:responded_in)
  end

  def all_response_times
    payload_requests.order('responded_in desc').pluck(:responded_in).join(", ")
  end

  def average_response_time
    payload_requests.average(:responded_in)
  end

  def all_http_verbs
    self.payload_requests.includes(:request_type).pluck(:request_type).uniq.join(", ")
  end

  def top_three_referrers
    referrers = self.payload_requests.group(:reference).order('count_all desc').limit(3).count
    referrers.map { |k, v| k.reference }.join(", ")
  end

  def top_three_user_agents
    ua = self.payload_requests.group(:software_agent).order('count_all desc').limit(3).count
    ua.map do |k, v|
      "#{k.os}, #{k.browser}"
    end.join(", ")
  end
end
