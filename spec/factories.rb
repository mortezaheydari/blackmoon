
FactoryGirl.define do


	fake_title = Faker::Lorem.sentence(1)

	factory :collective do
		sequence(:title) { |n| "collective title #{n}"}
	end

	factory :profile do
		about Faker::Lorem.paragraph(5)
		first_name Faker::Name.first_name
		last_name Faker::Name.last_name
	end

	factory :user do
		name Faker::Name.name
		profile
		album
	end

	factory :account do
		email Faker::Internet.email
		password "foobar"
		password_confirmation "foobar"
		factory :account_with_user do
			user
		end
	end

	factory :event do
		category Faker::Lorem.words.first
		custom_address (Faker::Address.city+", "+Faker::Address.street_address)
		sequence(:location_type) {|n| n%2}
		descreption Faker::Lorem.paragraph(3)
		title fake_title

		happening_case
		album 

	end

	factory :game do
		category Faker::Lorem.words.first
		custom_address (Faker::Address.city+", "+Faker::Address.street_address)
		sequence(:location_type) {|n| n%2}
		description Faker::Lorem.paragraph(3)
		title fake_title

		happening_case
		album 

	end	

	factory :album do
		title fake_title
	end

	factory :happening_case do
		date_and_time (Time.now + 1.day)
    	duration_type "All Day"
		title fake_title
		factory :happening_case_ranged do
    	    duration_type "Rang"
			time_from (Time.now + 1.day + 1.hour)
			time_to (Time.now + 1.day)
		end
	end

end