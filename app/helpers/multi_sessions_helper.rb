module MultiSessionsHelper

## regardig calendar system.

	def calendar(date = Date.today, &block)
		Calendar.new(self, date.to_date, block).table
	end

	class Calendar < Struct.new(:view, :date, :callback)
		HEADER = %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday]
		START_DAY = :sunday

		delegate :content_tag, to: :view

		def table
			content_tag :table, class: "calendar" do
				header + week_rows
			end
		end

		def header
			content_tag :tr do
				HEADER.map { |day| content_tag :th, day }.join.html_safe
			end
		end

		def week_rows
			weeks.map do |week|
				content_tag :tr do
					week.map { |day| day_cell(day) }.join.html_safe
				end
			end.join.html_safe
		end

		def day_cell(day)
			content_tag :td, view.capture(day, &callback), class: day_classes(day)
		end

		def day_classes(day)
			classes = []
			classes << "today" if day == Date.today
			classes << "notmonth" if day.month != date.month
			classes.empty? ? nil : classes.join(" ")
		end

		def weeks
			first = date.beginning_of_month.beginning_of_week(START_DAY)
			last = date.end_of_month.end_of_week(START_DAY)
			(first..last).to_a.in_groups_of(7)
		end
	end

##
	private
		# these methods are currently out of use
		def grouped_happening_cases(this)
			session_id_list = []
			this.offering_sessions.each do |os|
				session_id_list << os.id
			end

			sorted_happening_cases = HappeningCase.where(happening_type: "OfferingSession", happening_id: session_id_list).group_by(&:date_and_time)
		end

		def replace_with_happening(grouped_happening_cases)
			grouped_sessions = Hash.new
			grouped_happening_cases.each do |key, value|
				grouped_sessions[key.to_date] = []
				value.each do |happening_case|
					grouped_sessions[key.to_date] << happening_case.happening
				end
			end
			grouped_sessions
		end


end
