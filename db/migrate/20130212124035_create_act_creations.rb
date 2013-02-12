class CreateActCreations < ActiveRecord::Migration
  def change
    create_table :act_creations do |t|
      t.integer :creator_id
      t.integer :act_id
      t.string :act_type

      t.timestamps
    end
  end
end
