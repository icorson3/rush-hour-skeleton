class Resolution < ActiveRecord::Base
  validates :resolution_width, presence: true
  validates :resolution_height, presence: true

  has_many :payload_requests
  has_many :clients, through: :payload_requests

  def self.all_widths_by_heights
    self.pluck(:resolution_width, :resolution_height).map {|pair| pair.join("x")}
  end
end
