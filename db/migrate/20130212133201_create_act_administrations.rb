class CreateActAdministrations < ActiveRecord::Migration
  def change
    create_table :act_administrations do |t|
      t.integer :administrator_id
      t.integer :act_id
      t.string :act_type

      t.timestamps
    end
  end
end
