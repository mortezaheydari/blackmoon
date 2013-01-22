class CreateOfferingAdministrations < ActiveRecord::Migration
  def change
    create_table :offering_administrations do |t|
      t.integer :administrator_id
      t.integer :creator_id
      t.string :offering_type

      t.timestamps
    end
  end
end
