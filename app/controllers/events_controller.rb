class EventsController < ApplicationController
 	before_filter :authenticate_account!, only: [:new, :create, :edit, :destroy]
 	# before_filter :user_is_admin?(current_user, Event.find(params[:id])), only: [:edit]

  def index
    @events = Event.all
  end

  def new
  	@event = Event.new
  end

  def create
  	@event = Event.new(params[:event])
    @event.date_and_time = date_helper_to_str(params[:date_and_time])
    @event.save
  	@event.create_offering_creation(creator_id: current_user.id)
		redirect_to @event
  end

  def destroy
  	@user = current_user
  	@event = Event.find(params[:id])
		if true #user_is_admin?(@user, @event)
			@event.destroy
			@event.offering_creation.destroy
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
    @event.date_and_time = date_helper_to_str(params[:date_and_time])
    if @event.save
      redirect_to @event
    else
      render 'edit'
    end
	end

	private
		def date_helper_to_str(date)
			"#{date[:year]}-#{date[:month]}-#{date[:day]}"
		end

		# def user_is_admin?(user, offering)
		# 	offering.admins.include?(user)
		# end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= current_account.user
  end

  def current_user?(user)
    user == current_user
  end

end
