class MoonactorAbility < ActiveRecord::Base
  attr_accessible :owner_id, :owner_type, :create_event, :create_game, :create_group_training, :create_personal_trainer, :create_team, :create_venue

  belongs_to :owner, polymorphic: true, dependent: :destroy
end
