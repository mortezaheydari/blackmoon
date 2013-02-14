class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :title
      t.text :descreption
      t.string :sport

      t.timestamps
    end
  end
end
