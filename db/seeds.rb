# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#  SPORTS LIST 
	# list sports and their categories

		category_list = ["Ball Sport", "Fitness", "Water Sport"]

		ball_sport_list = ["Basketball",
			"Volleyball",
			"Football (Soccer)",
			"American Football",
			"Cricket",
			"Badminton",
			"Baseball",
			"Tennis",
			"Handball",
			"Table Tennis",
			"Foosball",
			"Squash",
			"Bowling",
			"Golf"]

		fitness_list = ["Cycling",
			"Karate",
			"Judo",
			"Boxing",
			"Kick Boxing",
			"Skating",
			"Running",
			"Power Walking",
			"Skateboarding",
			"Roller Skating",
			"Taekwondo",
			"Fencing",
			"Paint ball",
			"Yoga",
			"Aikido",
			"Aerobics",
			"Gymnastics"]

		water_sport_list = ["Swimming",
			"Water Polo",
			"Sailing",
			"Diving",
			"Fishing"]

	# create sports and their categories
		category_list.each do |category|
			if SportCategory.where(name: category).empty?
				SportCategory.create(name: category)
			end
		end 

		ball_sport_category = SportCategory.where(name: "Ball Sport").first
		ball_sport_list.each do |sport|
			if Sport.where(name: sport, sport_category_id: ball_sport_category.id).empty?
				Sport.create(name: sport, sport_category_id: ball_sport_category.id)
			end
		end

		fitness_category = SportCategory.where(name: "Fitness").first
		fitness_list.each do |sport|
			if Sport.where(name: sport, sport_category_id: fitness_category.id).empty?		
				Sport.create(name: sport, sport_category_id: fitness_category.id)
			end
		end

		water_sport_category = SportCategory.where(name: "Water Sport").first
		water_sport_list.each do |sport|
			if Sport.where(name: sport, sport_category_id: water_sport_category.id).empty?				
				Sport.create(name: sport, sport_category_id: water_sport_category.id)
			end
		end

		if AdminUser.all.empty?
			AdminUser.create!(:email => 'info@goboom.me', :password => 'goboom123', :password_confirmation => 'goboom123')
		end
	#
# DONE