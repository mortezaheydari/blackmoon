class InvitationsController < ApplicationController

	def create
		params_initializer

		unless @inviter.nil? @invited.nil? @subject.nil?
			if @subject.administrators.include? @inviter
				@invitation                     = Invitation.new
				@invitation.inviter             = @inviter
				@invitation.invited             = @invited
				@invitation.invited             = @invited
				@invitation.state               = "sent"
				@invitation.submission_datetime = Time.now
			else
				redirect_to @redirect_object, notice: 'you don\'t have premission' and return
			end

			double_check { @invitation }

            respond_to do |format|
                format.html { redirect_to @redirect_object, notice: 'invitation has been sent.' }
                format.js
            end
		end
	end

	def update
		@invitation     = Invitation.find_by_id(params[:invitation_id])
		redirect_object = find_and_assign redirect_object_type, redirect_object_id
		redirect_object = rooth_path if redirect_object.nil?

		if @invitation.invited = current_user
			if params[:respond] = "accept"
				@invitation.state = "accepted"
			elsif params[:respond] = "reject"
				@invitation.state = "rejected"
			else 
				redirect_to redirect_object, notice:'error' and return
			end
		@invitation.response_datetime = Time.now		
			
		double_check {@invitation.save}

        respond_to do |format|
            format.html { redirect_to redirect_object, notice: 'invitation has been sent.' }
            format.js
        end		

	end

	private
	
		def params_initializer
			inviter_id         = params[:inviter_id]
			inviter_type       = params[:inviter_type]
			invited_id         = params[:invited_id]
			invited_type       = params[:invited_type]
			subject_id         = params[:subject_id]
			subject_type       = params[:subject_type]
			return_object_id   = params[:return_object_id]
			return_object_type = params[:return_object_type]			

			@inviter           = find_and_assign inviter_type, inviter_id
			@invited           = find_and_assign invited_type, invited_id
			@subject           = find_and_assign subject_type, subject_id
			@redirect_object   = find_and_assign redirect_object_type, redirect_object_id

		end

	    def find_and_assign this_type, this_id
			unless this_type.nil? or this_id.nil?
				if ["user", "team"].includs? this_type.downcase and this_id.not_nil?
					double_check { this = this_type.camelize.constantize.find_by_id(this_id) }
				end
			end	    	
	    end

	    def double_check(&b)
	    	redirect_object = root_path
	    	redirect_object = @redirect_object unless @redirect_object.nil?
	        redirect_to redirect_object, notice: 'error' and return unless b.call == true
	    end

end
