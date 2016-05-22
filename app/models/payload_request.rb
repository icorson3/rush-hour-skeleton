class PayloadRequest < ActiveRecord::Base
  validates  :url_id,            presence: true
  validates  :requested_at,      presence: true
  validates  :responded_in,      presence: true
  validates  :reference_id,      presence: true
  validates  :request_type_id,   presence: true
  validates  :parameters,        presence: true
  validates  :event_name_id,     presence: true
  validates  :software_agent_id, presence: true
  validates  :resolution_id,     presence: true
  validates  :ip_address_id,     presence: true
  validates  :client_id,         presence: true

  validates :requested_at, uniqueness:
              {scope: [:url_id,
                      :responded_in,
                      :reference_id,
                      :request_type_id,
                      :parameters,
                      :event_name_id,
                      :software_agent_id,
                      :resolution_id,
                      :ip_address_id,
                      :client_id]}

  belongs_to :url
  belongs_to :reference
  belongs_to :request_type
  belongs_to :event_name
  belongs_to :software_agent
  belongs_to :resolution
  belongs_to :ip_address
  belongs_to :client

  def self.average_response_time
    self.average(:responded_in)
  end

  def self.maximum_response_time
    self.maximum(:responded_in)
  end

  def self.minimum_response_time
    self.minimum(:responded_in)
  end

  def self.find_hour_requested_at(array)
    hours = array.map { |payload| payload.requested_at.hour }
    self.formatted_arrays(hours)
  end

  def self.formatted_arrays(hours)
    adjusted = Array.new(24, 0)
    24.times { |i| adjusted[i] = hours.count(i) }
    adjusted
  end
end
