class EventsController < ApplicationController
  include SessionsHelper
 	before_filter :authenticate_account!, only: [:new, :create, :edit, :destroy]
 	before_filter :user_must_be_admin?, only: [:edit, :destroy]

  def index
    @events = Event.all
  end

  def new
  	@event = Event.new
  end

  def create
    @current_user_id = current_user.id
  	@event = Event.new(params[:event])
    @event.date_and_time = date_helper_to_str(params[:date_and_time])
    @event.save
  	@event.create_offering_creation(creator_id: @current_user_id)
    @event.offering_administrations.create(administrator_id: @current_user_id)
		redirect_to @event
  end

  def destroy
  	@user = current_user
  	@event = Event.find(params[:id])
		if true #user_is_admin?(@user, @event)
			@event.destroy
			# @event.offering_creation.destroy
      # @event.offering_administrations.destroy
  		redirect_to @event
  	else
  		render 'index'
  	end
  end

  def show
  	@event = Event.find(params[:id])
  end

  def edit
  	@event = Event.find(params[:id])
    @date_and_time = @event.date_and_time


  end

  def update
    @event = Event.find(params[:id])

    # @event.date_and_time = date_helper_to_str(params[:date_and_time])
    params[:event][:date_and_time] = date_helper_to_str(params[:date_and_time])
    if @event.update_attributes(params[:event])
      redirect_to @event
    else
      render 'edit'
    end
end

  def user_must_be_admin?
    @offering = Event.find(params[:id])
    @user = current_user
    redirect_to(@offering) unless @offering.administrators.include?(@user)
  end

end
