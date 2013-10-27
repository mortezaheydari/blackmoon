class CreateOfferingSessions < ActiveRecord::Migration
  def change
    create_table :offering_sessions do |t|
      t.string :title
      t.text :descreption
      t.integer :number_of_attendings
      t.string :owner_type
      t.integer :owner_id

      t.timestamps
    end
  end
end
