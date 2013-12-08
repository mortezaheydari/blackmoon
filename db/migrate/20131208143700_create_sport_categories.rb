class CreateSportCategories < ActiveRecord::Migration
  def change
    create_table :sport_categories do |t|
      t.string :name

      t.timestamps
    end
  end
end
