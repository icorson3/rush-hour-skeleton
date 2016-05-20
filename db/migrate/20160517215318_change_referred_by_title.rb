class ChangeReferredByTitle < ActiveRecord::Migration
  def change
    rename_table(:referred_bys, :references)
    rename_column(:references, :referred_by, :reference)
    remove_reference(:payload_requests, :referred_by, index: true)
    add_reference(:payload_requests, :reference, index: true)
  end
end
