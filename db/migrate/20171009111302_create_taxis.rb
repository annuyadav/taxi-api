class CreateTaxis < ActiveRecord::Migration[5.0]
  def change
    create_table :taxis do |t|
      t.string :color
      t.decimal :location_latitude, precision: 10, scale: 6, null: false
      t.decimal :location_longitude, precision: 10, scale: 6, null: false
      t.boolean :booked, default: false

      t.timestamps
    end
  end
end
