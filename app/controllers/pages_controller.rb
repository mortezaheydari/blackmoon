class PagesController < ApplicationController
  def home
    @account ||= Account.new
    @account.user ||= User.new
  end


    def offering_management

    end
end
