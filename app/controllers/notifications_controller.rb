class NotificationsController < ApplicationController
# TODO: controller might not be required

	def index
		@activities = PublicActivity::Activity.order("created_at desc").where(owner_type: 'User', owner_id: current_user)
	end	

end
