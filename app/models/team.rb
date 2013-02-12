class Team < ActiveRecord::Base
  attr_accessible :descreption, :name, :sport

	make_flaggable :like  

  has_one :act_creation, as: :act, :dependent => :destroy
  accepts_nested_attributes_for :act_creation	

  has_many :act_administrations, as: :act, :dependent => :destroy
  accepts_nested_attributes_for :act_administrations  

  has_many :act_memberships, as: :act, :dependent => :destroy
  accepts_nested_attributes_for :act_memberships  

	def creator
		User.find_by_id(self.act_creation.creator_id) unless self.act_creation.nil?
	end

	def administrators
		@admins = []
		self.act_administrations.each do |admin|
			@admins << admin.administrator_id 
		end
		User.find(@admins)
	end	

	def members
		@members = []
		self.act_memberships.each do |member|
			@members << member.administrator_id 
		end
		User.find(@members)
	end	

end
