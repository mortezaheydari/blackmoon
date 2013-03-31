class CreateHappeningCases < ActiveRecord::Migration
  def change
    create_table :happening_cases do |t|
      t.string :title
      t.integer :happening_id
      t.string :happening_type
      t.string :duration_type
      t.datetime :date_and_time
      t.time :time_from
      t.time :time_to

      t.timestamps
    end
  end
end
