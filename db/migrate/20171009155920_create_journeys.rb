class CreateJourneys < ActiveRecord::Migration[5.0]
  def change
    create_table :journeys do |t|
      t.integer :taxi_id
      t.decimal :start_latitude
      t.decimal :start_longitude
      t.decimal :end_latitude
      t.decimal :end_longitude
      t.datetime :start_time
      t.datetime :end_time
      t.integer  :state, default: 0

      t.timestamps
    end
  end
end
