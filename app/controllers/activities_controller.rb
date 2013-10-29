class ActivitiesController < ApplicationController

	def index
		@activities = PublicActivity::Activity.order("created_at desc").where(recipient_type: 'public')
	end

end
