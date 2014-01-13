class PgStringAndIntegerIssueFix < ActiveRecord::Migration
  def up
    change_column :offering_creations, :creator_id, :integer
  end

  def down
    change_column :offering_creations, :creator_id, :string
  end
end