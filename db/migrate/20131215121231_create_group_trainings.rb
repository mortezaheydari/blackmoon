class CreateGroupTrainings < ActiveRecord::Migration
  def change
    create_table :group_trainings do |t|
      t.string :title
      t.text :descreption

      t.timestamps
    end
  end
end
