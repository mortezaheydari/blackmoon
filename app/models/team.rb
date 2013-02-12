class Team < ActiveRecord::Base
  attr_accessible :descreption, :name, :sport

	make_flaggable :like  

  has_one :act_creation, as: :act, :dependent => :destroy
  accepts_nested_attributes_for :offering_creation	


	def creator
		User.find_by_id(self.act_creation.creator_id) unless self.act_creation.nil?
	end

end
