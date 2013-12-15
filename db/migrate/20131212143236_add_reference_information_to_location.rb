class AddReferenceInformationToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :parent_id, :integer
  end
end
