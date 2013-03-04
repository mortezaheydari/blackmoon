class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :title
      t.text :description
      t.string :location_type
      t.string :custom_address
      t.string :category
      t.datetime :date_and_time
      t.integer :tournament_id
      t.string :duration_type
      t.time :time_from
      t.time :time_to
      t.float :fee
      t.string :fee_type
      t.string :sport
      t.integer :number_of_attendings
      t.boolean :team_participation

      t.timestamps
    end
  end
end
