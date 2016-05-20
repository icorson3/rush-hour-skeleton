class CreateClient < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.text :identifier
      t.text :root_url
    end
    add_reference(:payload_requests, :client, index: true)
  end
end
