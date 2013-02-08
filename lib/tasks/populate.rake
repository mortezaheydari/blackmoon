namespace :db do
	desc "Fill database with sample data"
	task populate: :environment do
		make_accounts
	end
end

def make_accounts
	99.times do |n|
		first_name = Faker::Name.first_name
		last_name = Faker::Name.last_name		
		name = first_name+" "+last_name
		user_name = Faker::Internet.user_name(name)
		email = Faker::Internet.safe_email(user_name)
		address = Faker::Address.city+", "+Faker::Address.street_address
		phone = Faker::PhoneNumber.cell_phone
		about = Faker::Lorem.paragraph
		date_of_birth = "1988-06-06"
		password = "password"

		account = Account.create!({email: email, password: password, password_confirmation: password})	
		user = account.create_user!(name: name)	
		profile = user.profile
		profile ||= user.create_profile!(first_name: first_name, last_name: last_name, about: about, phone: phone, date_of_birth: date_of_birth)
	end			
end

