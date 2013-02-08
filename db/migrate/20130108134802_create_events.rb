class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.text :descreption
      t.string :location_type
      t.string :custom_address
      t.string :category
      t.datetime :date_and_time
      t.integer :tournament_id

      t.timestamps
    end
  end
end
