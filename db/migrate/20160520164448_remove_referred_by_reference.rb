class RemoveReferredByReference < ActiveRecord::Migration
  def change
    remove_reference(:payload_requests, :referred_by_id, index: true, foreign_key: true)
  end
end
