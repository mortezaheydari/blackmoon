class SuperUser < ActiveRecord::Migration
  def change
    change_table :moonactor_abilities do |t|

      t.boolean :create_venue, :default => true
      t.boolean :create_personal_trainer, :default => true
      t.boolean :create_group_training, :default => true

      t.timestamps
    end
  end
end
