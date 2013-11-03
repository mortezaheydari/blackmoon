class AddCollectionToOfferingSession < ActiveRecord::Migration
  def change
    add_column :offering_sessions, :collection_flag, :boolean, default: false
  end
end
