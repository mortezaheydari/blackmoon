# fake objects:
	def fake_title(); Faker::Lorem.sentence(1); end
	def fake_text(); Faker::Lorem.paragraph(3); end
	def fake_address(); Faker::Address.city+", "+Faker::Address.street_address; end
	def fake_word(); Faker::Lorem.words.first; end

FactoryGirl.define do

# factories:
	factory :offering_session do
		title {fake_title}
		descreption Faker::Lorem.paragraph(3)
		happening_case
		number_of_attendings 0
	end

	factory :photo do
		title {fake_title}
		image { fixture_file_upload(Rails.root.join('spec', 'photos', 'test.png'), 'image/png') }
	end

	factory :logo do
		photo
	end

	factory :collective do
		sequence(:title) { |n| "collective title #{n}"}
		factory :collective_for_venue do
			# find a solution for it
			# owner { venue }
		end
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
		factory :user_with_logo do
			logo			
		end
	end

	factory :account do
		email Faker::Internet.email
		password "foobar"
		password_confirmation "foobar"
		factory :account_with_user do
			user
		end
	end

	factory :location do

		title {fake_title}

		factory :location_with_gmap do

			latitude Faker::Address.latitude
			longitude Faker::Address.longitude
			gmap_use true			
			custom_address_use false	
		end

		factory :location_with_custom_address do
			city Faker::Address.city
			custom_address {fake_address}
			custom_address_use true
			gmap_use false
		end		
	end

	factory :event do
		category {fake_word}
		descreption Faker::Lorem.paragraph(3)
		title {fake_title}
		number_of_attendings 0		
		happening_case
		album
		factory :event_with_logo do
			logo
		end
		location
	end

	factory :game do
		category {fake_word}
		sequence(:location_type) {|n| n%2}
		description Faker::Lorem.paragraph(3)
		title {fake_title}
		number_of_attendings 0		
		happening_case
		album
		factory :game_with_logo do
			logo
		end
		location
	end	

	factory :team do
		descreption {fake_text}
		number_of_attendings 0
		title {fake_title}
		category {fake_word}
	end

	factory :venue do
		title {fake_title}
		descreption {fake_text}
		location 
	end

	factory :album do
		title {fake_title}
	end

	factory :happening_case do
		date_and_time (Time.now + 1.day)
    	duration_type "All Day"
		title {fake_title}
		factory :happening_case_ranged do
    	    duration_type "Rang"
			time_from (Time.now + 1.day + 1.hour)
			time_to (Time.now + 1.day)
		end
	end

end