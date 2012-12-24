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
  end
end