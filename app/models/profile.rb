class Profile < ActiveRecord::Base
  attr_accessible :about, :date_of_birth, :first_name, :gender, :last_name, :phone

	belongs_to :user
end
