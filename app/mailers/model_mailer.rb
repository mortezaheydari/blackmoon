class ModelMailer < ActionMailer::Base
  default from: "info@goboom.me"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.model_mailer.new_invitation_notification.subject
  #

  def new_invitation_notification(invitation)
     @invitation = invitation
     @offering = @invitation.subject
     @inviter = @invitation.inviter
  # mail to: @invitation.invited.account.email, subject: "Goboom - New invitation."
  mail to: "info.charchoob@gmail.com", subject: "Goboom - New invitation."
  end

  def individual_invitation_accepted_notification(invitation)
     @invitation = invitation
     @offering = @invitation.subject
     @invited = @invitation.invited
  # mail to: @invitation.inviter.account.email, subject: "Goboom - Invitation Accepted."
  mail to: "info.charchoob@mail.com", subject: "Goboom - Invitation Accepted."
  end

  def daily_notifications(user, today_schedules)
    @user = user
    @schedule = today_schedules

  # mail to: @user.account.email, subject: "Goboom - Today's Schedule."
  mail to: "info.charchoob@mail.com", subject: "Goboom - Today's Schedule."
  end

  def team_new_invitation_notification(invitation)
     @invitation = invitation
     @offering = @invitation.subject
     @invited_team = @invitation.invited
     @inviter = @invitation.inviter
  # mail to: "info.charchoob@gmail.com", subject: "Goboom - New invitation for '#{@invited_team.title}'."
  mail to: "info.charchoob@gmail.com", subject: "Goboom - New invitation for '#{@invited_team.title}'."
  end
end
