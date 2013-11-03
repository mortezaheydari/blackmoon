class OfferingSessionsController < ApplicationController
	
	include SessionsHelper
	before_filter :authenticate_account!, only: [:new, :create, :edit, :destroy, :like]  
	before_filter :user_must_be_admin?, only: [:edit, :destroy]

	def create

		# initial assignments
		owner_type = params[:owner_type]
		owner_id = params[:owner_id]
		params[:happening_case][:date_and_time] = date_helper_to_str(params[:date_and_time])

			double_check {
		name_is_valid?(owner_type) }

		@offering_session = OfferingSession.new

		# need collective or not?
		case params[:collective_type]

		when "", nil, " "
			# if creating mmultiple sessions, must automaticly create a collective to contain them. This allows user to delete those sessions easily in case of any mistakes by deleting the collectives.
			case params[:collective_flag]
			when "true"
				@collective = create_collective(params[:offering_session][:title], @owner.class.to_s, @owner.id)
				@offering_session.owner = @collective.owner
				@offering_session.collective = @collective
			else
				assign_offering_session_owner
				@offering_session.collection_flag = false
			end

		when "existing"
			assign_offering_session_owner
			@collective = owner_if_reachable("Collective", params[:collective_id])
			@offering_session.collection_id = @collctive.id

		when "new"
			@collective = create_collective(params[:collective_title], @owner.class.to_s, @owner.id)
			@offering_session.owner = @collective.owner
			@offering_session.collective = @collective

		else
			double_check { false }

		end

		# single or multiple?
		if params[:collective_flag] == "true"
			
			# create them (redirect if not)

			@repeat_duration = params[:repeat_duration]
			@repeat_number = params[:repeat_number].to_i
			@repeat_every = params[:repeat_every].to_i			

			# repeat request is proper?
			double_check(@owner) { 
				(["hour", "day", "month"].include? @repeat_duration) &&
				@repeat_number<26 &&
				@repeat_number>0 &&
				@repeat_every< 26 &&
				@repeat_every> 0 &&
				 }
			
			# build multiple sessions, if "All Day" or "Range"
			if params[:happening_case][:duration_type] == "All Day"
				double_check(@owner) { !(params[:repeat_duration] == "hour") }
				@repeat_number.times do |i|
				happening_case = @offering_session.build_happening_case(params[:happening_case])
				happening_case.date_and_time = (params[:happening_case][:date_and_time] + (@repeat_every.send(@repeat_duration))*i
				end

			elsif params[:happening_case][:duration_type] == "Range"
				@repeat_number.times do |i|
				happening_case = @offering_session.build_happening_case(params[:happening_case])
				happening_case.time_from = (params[:happening_case][:time_from] + (@repeat_every.send(@repeat_duration))*i
				happening_case.time_to = (params[:happening_case][:time_to] + (@repeat_every.send(@repeat_duration))*i				
				end

			else
				double_check(@owner) { false }
			end

				double_check(@owner) {
			offering_session.save }

		else
			@offering_session.build_happening_case(params[:happening_case])

				double_check {
			@offering_session.save }
		end

		# return message.
		msg = "Session has been created."
		msg = "Sessions have been created."params[:collective_flag] == "true"

	    respond_to do |format|
	        format.html { redirect_to @owner, notice: msg }
	        format.js
	    end

	end

	def update # session
		# find owner and session
		# check permissions

	end

	def destroy # session
		
	end

	# secondary methods

	def release
		
	end

	def destroy_collective
		
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
				owner = owner_if_reachable(owner_type, owner_id)
				collective.owner = owner				
			end
				double_check { 
			collective.save }
			collective
		end

		def assign_offering_session_owner
			@owner = owner_if_reachable(params[:owner_type], params[:owner_id])
			@offering_session.owner = @owner
		end
end
