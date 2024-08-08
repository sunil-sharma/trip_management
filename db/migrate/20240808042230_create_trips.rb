class CreateTrips < ActiveRecord::Migration[5.1]
  def change
    create_table :trips do |t|
      t.datetime :estimated_arrival
      t.datetime :estimated_completion
      t.string :status
      t.datetime :check_in_time
      t.datetime :check_out_time

      t.timestamps
    end
  end
end
