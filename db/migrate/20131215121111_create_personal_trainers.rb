class CreatePersonalTrainers < ActiveRecord::Migration
  def change
    create_table :personal_trainers do |t|
      t.string :title
      t.text :descreption

      t.timestamps
    end
  end
end
