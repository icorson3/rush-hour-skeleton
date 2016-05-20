class Client < ActiveRecord::Base
  validates :identifier, presence: true, uniqueness: true
  validates :root_url, presence: true

  has_many :payload_requests

end