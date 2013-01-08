
FactoryGirl.define do

	factory :profile do
		sequence(:about) { |n| "about #{n}"}
		sequence(:first_name) { |n| "name #{n}"}
		sequence(:last_name) { |n| "last_name #{n}"}
		user
	end

	factory :user do
		sequence(:name) { |n| "Persone #{n}"}
		account
	end

	factory :account do
    sequence(:email) { |n| "persone_#{n}@example.com" }
    password "foobar"
    password_confirmation "foobar"

    factory :account_with_user do
			user
    end
  end

  factory :event do
		sequence(:category) {|n| "category#{n%5}"}
		sequence(:custom_address) {|n| Faker::Address.city+", "+Faker::Address.street_address}
		sequence(:date_and_time) {|n| rand_time(100.years.ago)}
		sequence(:descreption) {|n| Faker::Lorem.paragraph(3)}
		sequence(:location_type) {|n| n%2}
		sequence(:title) {|n| Faker::Lorem.sentence(1)}
  end
end