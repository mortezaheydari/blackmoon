class PgStringAndIntegerIssueFix < ActiveRecord::Migration
  def up
    connection.execute(%q{
    alter table offering_creations
    alter column creator_id
    type integer using cast(number as integer)
  	})
  end

  def down
    change_column :offering_creations, :creator_id, :string
  end
end