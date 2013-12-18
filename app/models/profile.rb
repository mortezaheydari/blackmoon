class Profile < ActiveRecord::Base
  attr_accessible :about, :date_of_birth, :first_name, :gender, :last_name, :phone, :daily_email_option

  # validates_length_of :about, within: 1..120, on: :update, message: "must be between 10 to 120 charachters."

	belongs_to :user
end
