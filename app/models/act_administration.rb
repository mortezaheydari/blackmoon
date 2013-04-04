class ActAdministration < ActiveRecord::Base

  include PublicActivity::Model  
  attr_accessible :act_id, :act_type, :administrator_id

  belongs_to :act, polymorphic: true
  belongs_to :administrator, :class_name => "User", :foreign_key => "administrator_id"    

end
