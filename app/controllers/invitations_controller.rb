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
            @invitation.create_activity :create, owner: @invitation.inviter, recipient: @invitation.invited
            respond_to do |format|
                format.html { redirect_to(@redirect_object, notice: 'invitation has been sent.') and return }
                format.js { render('invitations/create', :locals => { this: @subject, person: @invited }) and return  }
            end
        end
        redirect_to(@redirect_object, notice: 'there was a problem with the request.') and return
    end

    def update
        @invitation     = Invitation.find_by_id(params[:id])
        invitation_respond = params[:respond]
        redirect_object

        if @invitation.invited == current_user
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

            else
                redirect_to(@redirect_object, notice:'error') and return

            end

            @invitation.response_datetime = Time.now

            double_check {@invitation.save}
            @invitation.create_activity :update, owner: @invitation.invited, recipient: @invitation.inviter
            respond_to do |format|
                format.html { redirect_to(@redirect_object, notice: 'sent.' ) and return }
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
end
