class CreateTripVersions < ActiveRecord::Migration[5.1]
  def change
    create_table :trip_versions do |t|
      t.references :trip, foreign_key: true
      t.references :owner,  null: false, foreign_key: { to_table: :users }
      t.references :assignee, null: false, foreign_key: { to_table: :users }
      t.timestamps
    end
  end
end
