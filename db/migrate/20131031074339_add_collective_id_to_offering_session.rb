class AddCollectiveIdToOfferingSession < ActiveRecord::Migration
  def change
    add_column :offering_sessions, :collective_id, :integer
  end
end
