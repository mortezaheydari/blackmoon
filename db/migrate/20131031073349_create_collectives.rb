class CreateCollectives < ActiveRecord::Migration
  def change
    create_table :collectives do |t|
      t.string :title,      :null => false
      t.string :owner_type,      :null => false
      t.integer :owner_id,      :null => false

      t.timestamps
    end
  end
end
