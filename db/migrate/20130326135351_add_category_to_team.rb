class AddCategoryToTeam < ActiveRecord::Migration
  def change
    add_column :teams, :category, :string
  end
end
