class OfferingSessionsController < ApplicationController

	include SessionsHelper
	before_filter :authenticate_account!, only: [:new, :create, :edit, :destroy, :like]
	before_filter :user_must_be_admin?, only: [:edit, :destroy]

	def create

		# initial assignments
		owner_type = params[:offering_session][:owner_type]
		owner_id = params[:offering_session][:owner_id]
		params[:happening_case][:date_and_time] = params[:happening_case][:date_and_time]

			double_check {
		name_is_valid?(owner_type) }

		@offering_session = OfferingSession.new(descreption: params[:offering_session][:descreption], number_of_attendings: params[:offering_session][:number_of_attendings], title: params[:offering_session][:title])

		# need collective or not?
		case params[:offering_session][:collective_type]

		when "", nil, " ", "none"
			# if creating mmultiple sessions, must automaticly create a collective to contain them. This allows user to delete those sessions easily in case of any mistakes by deleting the collectives.
			case params[:offering_session][:collection_flag]
			when "1"
                                                assign_offering_session_owner
				@collective = create_collective(params[:offering_session][:title], @owner.class.to_s, @owner.id)
				# @offering_session.owner = @collective.owner
				@offering_session.collective = @collective
			else
				assign_offering_session_owner
				@offering_session.collection_flag = false
			end

		when "existing"
			assign_offering_session_owner
			@collective = owner_if_reachable("Collective", params[:offering_session][:collective_id])
			@offering_session.collective_id = @collective.id

		when "new"
                                    assign_offering_session_owner
			@collective = create_collective(params[:offering_session][:collective_title], @owner.class.to_s, @owner.id)
			# @offering_session.owner = @collective.owner
			@offering_session.collective = @collective

		else
			double_check { false }

		end

		# single or multiple?
		if params[:offering_session][:collection_flag] == "1"

			# create them (redirect if not)

			@repeat_duration = params[:offering_session][:repeat_duration]
			@repeat_number = params[:offering_session][:repeat_number].to_i
			@repeat_every = params[:offering_session][:repeat_every].to_i

			# repeat request is proper?
			double_check(@owner) {
				(["hour", "day", "month"].include? @repeat_duration) #&&
				# @repeat_number < 26 &&
				# @repeat_number > 0 &&
				# @repeat_every < 26 &&
				# @repeat_every > 0
				 }
                                    @attributes = @offering_session.attributes
                                    ["id", "created_at", "updated_at"].each do |key|
                                        @attributes.delete key
                                    end
			# build multiple sessions, if "All Day" or "Range"
			if params[:happening_case][:duration_type] == "All Day"
				double_check(@owner) { !(params[:offering_session][:repeat_duration] == "hour") }
				@repeat_number.times do |i|
                                                            @the_offering_session = OfferingSession.new(@attributes)
            				happening_case = @the_offering_session.build_happening_case(params[:happening_case])
            				happening_case.date_and_time = (happening_case.date_and_time + (@repeat_every.send(@repeat_duration))*i)
                                                            @the_offering_session.save
				end

			elsif params[:happening_case][:duration_type] == "Range"

                                            # @offering_sessions_list = Hash.new

                                            @repeat_number.times do |i|
                                                @the_offering_session = OfferingSession.new(@attributes)

				happening_case = @the_offering_session.build_happening_case(params[:happening_case])
				happening_case.time_from = (happening_case.time_from + (@repeat_every.send(@repeat_duration))*i)
				happening_case.time_to = (happening_case.time_to + (@repeat_every.send(@repeat_duration))*i)
                                                @the_offering_session.save

			         end

			else
				double_check(@owner) { false }
			end

		else
			@offering_session.build_happening_case(params[:happening_case])

				double_check { @offering_session.save }
		end

	    # return message.
	    msg = "Session has been created."
	    msg = "Sessions have been created." if params[:offering_session][:collection_flag] == "true"

                @grouped_happening_cases = grouped_happening_cases(@owner)
                @grouped_sessions = replace_with_happening(@grouped_happening_cases)
                @date = params[:date] ? Date.parse(params[:date]) : Date.today

	    respond_to do |format|
	        format.html { redirect_to @owner, notice: msg }
                    format.js { render 'offering_sessions/update', :locals => { grouped_sessions: @grouped_sessions, owner: @owner } }
	    end

	end

	def update # offering_session
		# find owner and offering_session

                        # to be refactored
                        # @owner = params[:offering_session][:owner_type].constantize.find(params[:offering_session][:owner_id])
                        @owner = owner_if_reachable(params[:offering_session][:owner_type], params[:offering_session][:owner_id])


		@offering_session = OfferingSession.find(params[:id])
			double_check(@owner) {
		@owner.offering_sessions.include? @offering_session	}

		# check validity of attributes (TBD)

			double_check(@owner, "This session has participators and can not be updated.") {
		@offering_session.individual_participators.count == 0 }
                        unless params[:offering_session][:collective_type] == "none" || @offering_session.collective_id == params[:offering_session][:collective_id]
            		@collective = Collective.find params[:offering_session][:collective_id]
            			double_check {
                		@owner.collectives.include? @collective }
                        end

                        params[:offering_session].delete :collective_type

                        # to be used in case of changing collective_title
                        collective_title = params[:offering_session].delete :collective_title

			double_check {
    	@offering_session.update_attributes(params[:offering_session]) } # should become more secure in future.
			double_check {
    	@offering_session.happening_case.update_attributes(params[:happening_case]) } # should become more secure in future.



        @grouped_happening_cases = grouped_happening_cases(@owner)
        @grouped_sessions = replace_with_happening(@grouped_happening_cases)
        @date = params[:date] ? Date.parse(params[:date]) : Date.today

	    respond_to do |format|
	        format.html { redirect_to @owner, notice: "Session has been updated." }
	        format.js { render 'offering_sessions/update', :locals => { grouped_sessions: @grouped_sessions, owner: @owner } }
	    end
	end

	def destroy # offering_session
		@owner = owner_if_reachable(params[:owner_type], params[:owner_id])
		@offering_session.find(params[:offering_session_id])
			double_check(@owner) {
		@owner.offering_sessions.include? @offering_session	}

			double_check(@owner, "This session has participators and can not be deleted.") {
		@offering_session.individual_participators.count == 0 }

			double_check(@owner) {
		@offering_session.destroy }

	    respond_to do |format|
	        format.html { redirect_to @owner, notice: "Session has been deleted." }
	        format.js
	    end
	end

	# secondary methods

	def release
		@owner = owner_if_reachable(params[:owner_type], params[:owner_id])
		@offering_session.find(params[:offering_session_id])
			double_check(@owner) {
		@owner.offering_sessions.include? @offering_session	}

		@offering_session.collection_flag = false
		@offering_session.collective_id = nil

			double_check(@owner) {
		@offering_session.save	}

	    respond_to do |format|
	        format.html { redirect_to @owner, notice: "Session has been released from collective." }
	        format.js
	    end
	end

	def destroy_collective
		@owner = owner_if_reachable(params[:owner_type], params[:owner_id])
		@collective = Collective.find(params[:owner_id])
			double_check {
		@owner.collectives.include? @collective }

		# explode or destroy
		if params[:explode] == true
			@collective.offering_sessions.each do |offering_session|
				offering_session.collection_flag = false
				offering_session.collective_id = nil
				double_check(@owner) {
				offering_session.save }
			end
				double_check(@owner) {
			@collective.destroy }
			@msg = "Collective has been destroyed while keeping its sessions."
		else
				double_check(@owner) {
			@collective.destroy }
			@msg = "Collective has been destroyed alongside its sessions."
		end

	    respond_to do |format|
	        format.html { redirect_to @owner, notice: "Collective has been destroyed." }
	        format.js
	    end

	end

	private

                        def grouped_happening_cases(this)
                            session_id_list = []
                            this.offering_sessions.each do |os|
                                session_id_list << os.id
                            end
                            sorted_happening_cases = HappeningCase.where(happening_type: "OfferingSession", happening_id: session_id_list).group_by(&:date_and_time)
                        end

		def user_must_be_admin?
			@event = Event.find(params[:id])
			@user = current_user
			redirect_to(@event) unless @event.administrators.include?(@user)
		end

		def create_collective(title, owner_type, owner_id, owner_safe=false)
			name_is_valid?(owner_type)
			collective = Collective.new(title: title, owner_type: owner_type, owner_id: owner_id)
			# if owner_safe
			# 	collective.owner_type = owner_type
			# 	collective.owner_id = owner_id
			# else
			# 	owner = owner_if_reachable(owner_type, owner_id)
			# 	collective.owner = owner
			# end
				double_check {
			collective.save }
			collective
		end

		def assign_offering_session_owner
			@owner = owner_if_reachable(params[:offering_session][:owner_type], params[:offering_session][:owner_id])
			@offering_session.owner = @owner
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
