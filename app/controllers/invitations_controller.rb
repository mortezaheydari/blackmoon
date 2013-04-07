class InvitationsController < ApplicationController

    def create
        create_params_initializer

        unless @inviter.nil? || @invited.nil? || @subject.nil?
            if @subject.administrators.include? @inviter
                @invitation                     = Invitation.new
                @invitation.inviter             = @inviter
                @invitation.invited             = @invited
                @invitation.subject             = @subject
                @invitation.state               = "sent"
                @invitation.submission_datetime = Time.now
            else
                redirect_to(@redirect_object, notice: 'you don\'t have premission') and return
            end

            double_check { @invitation.save }
<<<<<<< HEAD
            @invitation.create_activity :create, owner: @invitation.inviter, recipient: @invitation.invited
=======
            @invitation.create_activity 
>>>>>>> add-modal
            respond_to do |format|
                format.html { redirect_to(@redirect_object, notice: 'invitation has been sent.') and return }
                format.js { render('invitations/create', :locals => { this: @subject, person: @invited }) and return  }
            end
        end
        redirect_to(@redirect_object, notice: 'there was a problem with the request.') and return
    end

    def update
        @invitation     = Invitation.find_by_id(params[:invitation_id])

        redirect_object

        if @invitation.invited = current_user
            if params[:respond] = "accept"
                @invitation.state = "accepted"
                
            elsif params[:respond] = "reject"
                @invitation.state = "rejected"
            else
                redirect_to(@redirect_object, notice:'error') and return
            end

            @invitation.response_datetime = Time.now

            double_check {@invitation.save}
            @invitation.create_activity :update, owner: @invitation.inviter, recipient: @invitation.invited
            respond_to do |format|
                format.html { redirect_to(@redirect_object, notice: 'invitation has been sent.' ) and return }
                format.js
            end
        else
            redirect_to(rooth_path, notice: "error") and return
        end

    end

    private

        def create_params_initializer
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
        end

        def redirect_object
            return_object_id   = params[:return_object_id]
            return_object_type = params[:return_object_type]
            @redirect_object   = find_and_assign return_object_type, return_object_id
            @redirect_object = root_path if @redirect_object.nil?
        end

        def find_and_assign this_type, this_id

            if ["user", "team", "event"].include? this_type.downcase and this_id
                a = root_path
                a = @redirect_object unless @redirect_object.nil?
                redirect_to(a, notice: 'error') and return unless this = this_type.camelize.constantize.find_by_id(this_id)
                this
            end
        end

    def double_check(&b)
        a = root_path
        a = @redirect_object unless @redirect_object.nil?
        redirect_to(a, notice: 'error') and return unless b.call == true
    end

end
