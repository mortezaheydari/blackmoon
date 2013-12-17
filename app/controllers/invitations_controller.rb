class InvitationsController < ApplicationController

	def create
		inviter_id         = params[:inviter_id]
		inviter_type       = params[:inviter_type]
		invited_id         = params[:invited_id]
		invited_type       = params[:invited_type]
		subject_id         = params[:subject_id]
		subject_type       = params[:subject_type]

		@inviter           = find_and_assign inviter_type, inviter_id
		@invited           = find_and_assign invited_type, invited_id
		@subject           = find_and_assign subject_type, subject_id

		redirect_object

		unless !@inviter.nil? && !@invited.nil? && !@subject.nil?; raise Errors::FlowError.new; end

		if !@subject.administrators.include? @inviter; raise Errors::FlowError.new(@redirect_object, 'you don\'t have premission'); end

		@invitation                     = Invitation.new
		@invitation.inviter             = @inviter
		@invitation.invited             = @invited
		@invitation.subject             = @subject
		@invitation.state               = "sent"
		@invitation.submission_datetime = Time.now

		if !@invitation.save; raise Errors::FlowError.new; end

		@invitation.create_activity :create, owner: @invitation.inviter, recipient: @invitation.invited
		ModelMailer.new_invitation_notification(@invitation).deliver

		respond_to do |format|
			format.html { redirect_to(@redirect_object, notice: 'invitation has been sent.') and return }
			format.js { render('invitations/create', :locals => { this: @subject, person: @invited }) and return  }
		end
	end

	def update
		@invitation     = Invitation.find_by_id(params[:id])
		invitation_respond = params[:respond]
		redirect_object

		if @invitation.invited != current_user; raise Errors::FlowError.new; end

		unless ["reject", "accept"].include? invitation_respond; raise Errors::FlowError.new; end

		if invitation_respond == "reject"
			@invitation.state = "rejected"

		elsif invitation_respond == "accept"
			@invitation.state = "accepted"

			if @invitation.invited.class.to_s == "User"
				offering_type = k_lower(@invitation.subject)
				if @invitation.subject.class.to_s == "Team"
					offerings_participating = @invitation.invited.send("#{offering_type}s_membership")
				else
					offerings_participating = @invitation.invited.send("#{offering_type}s_participating")
				end
				offerings_participating << @invitation.subject unless offerings_participating.include? @invitation.subject
				@invitation.subject.create_activity key: "offering_individual_participation.create", owner: current_user, recipient: @invitation.invited

			elsif @invitation.invited.class.to_s == "Team"
				offering_type = k_lower(@invitation.subject)
				offerings_participating = @invitation.invited.send("#{offering_type}s_participating")
				offerings_participating << @invitation.subject unless offerings_participating.include? @invitation.subject
				@invitation.subject.create_activity key: "offering_team_participation.create", owner: current_user, recipient: @invitation.invited
			end
		end

		@invitation.response_datetime = Time.now

		if !@invitation.save; raise Errors::FlowError.new; end

		if @invitation.invited.class.to_s == "User" && @invitation.state = "accepted"
			ModelMailer.individual_invitation_accepted_notification(@invitation).deliver
		end

		@invitation.create_activity :update, owner: @invitation.invited, recipient: @invitation.inviter

		respond_to do |format|
			format.html { redirect_to(@redirect_object, notice: 'sent.' ) and return }
			format.js
		end
	end

	private
	#REFACTOR: bad use of helper methods, too many variables.

		def create_params_initializer

		end


		def redirect_object
			if params[:redirect_object]
				@redirect_object = params[:redirect_object]
			else
				return_object_id   = params[:return_object_id]
				return_object_type = params[:return_object_type]
				@redirect_object   = find_and_assign return_object_type, return_object_id
			end
			@redirect_object = root_path if (@redirect_object.nil? || @redirect_object == false)
		end
end
