class User < ActiveRecord::Base
  attr_accessible :name
  validates :name, presence: true, length: {maximum: 50}, uniqueness: true

  has_one :profile
  belongs_to :account
end
