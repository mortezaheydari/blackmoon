class CreateOfferingCreations < ActiveRecord::Migration
  def change
    create_table :offering_creations do |t|
      t.string :creator_id
      t.integer :offering_id
      t.string :offering_type

      t.timestamps
    end
  end
end
