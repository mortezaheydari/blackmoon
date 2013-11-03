class Collective < ActiveRecord::Base

  include PublicActivity::Model
  	
  attr_accessible :owner_id, :owner_type, :title
  belongs_to :owner, polymorphic: true; accepts_nested_attributes_for :owner
  has_many :offering_sessions, :dependent => :destroy 
end
