class OfferingSessionsController < ApplicationController
  
  include SessionsHelper
  before_filter :authenticate_account!, only: [:new, :create, :edit, :destroy, :like]  
  before_filter :user_must_be_admin?, only: [:edit, :destroy]

  def create
    
  end

  def update
     
  end

  def destroy
    
  end

  def user_must_be_admin?
    @event = Event.find(params[:id])
    @user = current_user
    redirect_to(@event) unless @event.administrators.include?(@user)
  end

end
