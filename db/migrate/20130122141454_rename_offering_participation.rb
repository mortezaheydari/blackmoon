class RenameOfferingParticipation < ActiveRecord::Migration
  def up
  	rename_table :offering_participations, :offering_individual_participations
  end

  def down
  	rename_table :offering_individual_participations, :offering_participations
  end
end
