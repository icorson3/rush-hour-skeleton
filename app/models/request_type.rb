class RequestType < ActiveRecord::Base
  validates "request_type", presence: true

  belongs_to :payload_requests

  def self.all_verbs
    self.all.map { |verb| verb.request_type }
  end

  def self.most_frequent_request_verbs
    PayloadRequest.group(:request_type)
    require "pry"; binding.pry
  end
end
