class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.title :name
      t.text :descreption
      t.string :sport

      t.timestamps
    end
  end
end
