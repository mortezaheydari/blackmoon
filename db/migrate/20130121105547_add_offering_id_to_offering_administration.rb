class AddOfferingIdToOfferingAdministration < ActiveRecord::Migration
  def change
		add_column :offering_administrations, :offering_id, :integer
		remove_column :offering_administrations, :creator_id
  end
end
