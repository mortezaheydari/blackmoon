module HappeningSchedulesHelper

	def self.send_daily_notifications
		users = User.all

		users.each do |user|
			if user.wants_daily_emails?
				datetiem_from = Time.zone.now.beginning_of_day
				datetime_to = datetime_from + 24.hour
				today_schedules = user.happening_schedules.where("date_and_time >= ? And date_and_time =< ? ", datetime_from, datetime_to).order(date_and_time: :desc)
				if ModelMailer.daily_notifications(user, today_schedules).deliver
					today_schedules.each do |happening_schedule|
						happening_schedule.email_delivered = true
						happening_schedule.save
					end
				else
					today_schedules.each do |happening_schedule|
						happening_schedule.email_delivered = false
						happening_schedule.delivery_failure_count += 1
						happening_schedule.save
					end
				end
			end
		end		
	end

end