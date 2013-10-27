class CreateVenues < ActiveRecord::Migration
  def change
    create_table :venues do |t|
      t.string :title
      t.text :descreption

      t.timestamps
    end
  end
end
