class CreateSports < ActiveRecord::Migration
  def change
    create_table :sports do |t|
      t.string :name
      t.integer :sport_category_id

      t.timestamps
    end
  end
end
