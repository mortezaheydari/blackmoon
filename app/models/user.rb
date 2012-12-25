class User < ActiveRecord::Base
  attr_accessible :name, :profile_attributes
  validates :name, presence: true, length: {maximum: 50}, uniqueness: true

  has_one :profile
  accepts_nested_attributes_for :profile  
  belongs_to :account
end
