class CreateOfferingIndividualParticipations < ActiveRecord::Migration
  def change
    create_table :offering_participations do |t|
      t.integer :participator_id
      t.integer :offering_id
      t.string :offering_type

      t.timestamps
    end
  end
end
