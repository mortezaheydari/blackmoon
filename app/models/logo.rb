class Logo < ActiveRecord::Base
  attr_accessible :owner_id, :owner_type

	belongs_to :photo
	accepts_nested_attributes_for :photo	
	belongs_to :owner, polymorphic: true
	
end
