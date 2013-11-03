class OfferingSessionsController < ApplicationController
	
	include SessionsHelper
	before_filter :authenticate_account!, only: [:new, :create, :edit, :destroy, :like]  
	before_filter :user_must_be_admin?, only: [:edit, :destroy]

	def create
		owner_type = params[:owner_type]
		owner_id = params[:owner_id]
		params[:happening_case][:date_and_time] = date_helper_to_str(params[:date_and_time])
			double_check {
		name_is_valid?(owner_type) }

		# find owner object

		# checking permission
		double_check
		@offering_session = OfferingSession.new

		case params[:collective_type]

		when "", nil, " "
			assign_offering_session_owner
			@offering_session.collection_flag = false
		when "existing"
			assign_offering_session_owner

			@collective = owner_if_reachable?("Collective", params[:collective_id])

				double_check {
			@collective = Collective.find(params[:collective_id]) }

			@offering_session.collection_id = @collctive.id
		when "new"
			# create collection (redirect if not)

			@collective = create_collective(params[:collective_title], @owner.class.to_s, @owner.id)
			@offering_session.owner = @collective.owner
			@offering_session.collective = @collective
		else
			double_check { false }
		end

		if params[:collective_flag] == "true"
			
			# create them (redirect if not)

			@repeat_duration = params[:repeat_duration]
			@repeat_number = params[:repeat_number].to_i

			# double_check repeat request is proper, (redirect if not)
			double_check { ["hour", "day", "month"].include? @repeat_duration }
			double_check { @repeat_number<26 && @repeat_number>0 }
			if

		else
				double_check {
			@offering_session.save }

			@offering_session.create_happening_case(params[:happening_case])			

		end

	end

	def update # session
		 
	end

	def destroy
		
	end

	def assign_collection
		
	end
	
	private
	
		def user_must_be_admin?
			@event = Event.find(params[:id])
			@user = current_user
			redirect_to(@event) unless @event.administrators.include?(@user)
		end

		def new_collective(title, owner_type, owner_id, owner_safe=false)
			name_is_valid?(owner_type)
			collective = Collective.new(title: title, owner_type: owner_type, owner_id: owner_id)		
			if owner_safe
				collective.owner_type = owner_type
				collective.owner_id = owner_id
			else
				owner = owner_if_reachable?(owner_type, owner_id)
				collective.owner = owner				
			end
				double_check { 
			collective.save }
			collective
		end

		def assign_offering_session_owner
			@owner = owner_if_reachable?(params[:owner_type], params[:owner_id])
			@offering_session.owner = @owner
		end
end
