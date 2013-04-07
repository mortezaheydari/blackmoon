class PagesController < ApplicationController
  include SessionsHelper


    before_filter :authenticate_account!, only: [:offering_management, :notification]


  def home
    @account ||= Account.new
    @account.user ||= User.new
    @recent_activities =  PublicActivity::Activity.all(order: 'created_at desc')
  end


    def offering_management

    end

    def notification
        @recent_activities =  PublicActivity::Activity.where(recipient_type: "User", recipient_id: current_user.id)
        @recent_activities = @recent_activities.order("created_at desc")
    end
end
