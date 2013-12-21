class CreateMoonactorAbilities < ActiveRecord::Migration
  def change
    create_table :moonactor_abilities do |t|
      t.belongs_to :owner, :polymorphic => true      
      t.boolean :create_event, :default => true
      t.boolean :create_game, :default => true
      t.boolean :create_team, :default => true
      t.boolean :create_venue, :default => false
      t.boolean :create_personal_trainer, :default => false
      t.boolean :create_group_training, :default => false

      t.timestamps
    end
  end
end
