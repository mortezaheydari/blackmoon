module ApplicationHelper
	include SessionsHelper
	
# http://stackoverflow.com/questions/2410639/best-way-to-create-random-datetime-in-rails

	# generates random integer
	# example:		
	# rand_int(60, 75)
	# => 61
	def rand_int(from, to)
	  rand_in_range(from, to).to_i
	end

	# generates random price
	# defult 10 to 100
	# example:	
	# rand_price(10, 100)
	# => 43.84
	def rand_price(from=0, to=100)
	  rand_in_range(from, to).round(2)
	end

	# generate random time
	# defult 100 years ago to now
	# example:
	# rand_time(2.days.ago)
	# => Mon Mar 08 21:11:56 -0800 2010
	def rand_time(from=100.years.ago, to=Time.now)
	  Time.at(rand_in_range(from.to_f, to.to_f))
	end


	# methods regarding offered sports, (refer to seed)
	def ball_sport_list
		SportCategory.where(name: "Ball Sport").first.sports
	end
	def ball_sport_names_list
		list = []
		ball_sport_list.each do |sport|
			list << sport.name
		end
		list
	end

	def fitness_list
		SportCategory.where(name: "Ball Sport").first.sports
	end
	def fitness_names_list
		list = []
		fitness_list.each do |sport|
			list << sport.name
		end
		list		
	end

	def water_sport_list
		SportCategory.where(name: "Ball Sport").first.sports
	end
	def water_sport_names_list
		list = []
		water_sport_list.each do |sport|
			list << sport.name
		end
		list		
	end


end
