class PagesController < ApplicationController
  def home
    @account ||= Account.new
    @account.user ||= User.new
    @recent_activities =  PublicActivity::Activity.all(order: 'created_at desc')
  end


    def offering_management

    end
end
