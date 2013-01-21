class Profile < ActiveRecord::Base
  attr_accessible :about, :date_of_birth, :first_name, :gender, :last_name, :phone

  validates_length_of :about, within: 10..120, on: :update, message: "must be between 10 to 120 charachters."


	belongs_to :user
end
