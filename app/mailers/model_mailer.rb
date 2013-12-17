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

  def individual_invitation_accepted_notification
     @invitation = invitation
     @offering = @invitation.subject
     @invited = @invitation.invited
  # mail to: @invitation.inviter.account.email, subject: "Goboom - Invitation Accepted."
  mail to: "info.charchoob@gmail.com", subject: "Goboom - Invitation Accepted."  
  end
end
