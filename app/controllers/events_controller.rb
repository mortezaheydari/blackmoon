class EventsController < ApplicationController
  include SessionsHelper
 	before_filter :authenticate_account!, only: [:new, :create, :edit, :destroy, :like]
 	before_filter :user_must_be_admin?, only: [:edit, :destroy]

  def like
    @event = Event.find(params[:id])

    if current_user.flagged?(@event, :like)
      current_user.unflag(@event, :like)
      msg = "you now don't like this event."
    else
      current_user.flag(@event, :like)
      msg = "you now like this event."
    end
    respond_to do |format|
        format.html { redirect_to @event}
        format.js
    end
  end

  def like_cards
    @event = Event.find(params[:id])

    # current_user.unflag(@event, :like)
    current_user.toggle_flag(@event, :like)
    respond_to do |format|
        format.js { render 'events/like_cards', :locals => { style_id: params[:style_id], class_name: params[:class_name] } }
    end
  end

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
    @event.team_participation ||= false
    @event.save
    @event.create_offering_creation(creator_id: @current_user_id)
    @event.offering_administrations.create(administrator_id: @current_user_id)
    redirect_to @event
  end

  def destroy
  	@user = current_user
  	@event = Event.find(params[:id])
    if user_is_admin?(@event) && user_created_this?(@event)
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
           @likes = @event.flaggings.with_flag(:like)
           # flaggings.each do |flagging|
           #      @likes = []
           #      @likes << flagging.flagger
           # end
           if @event.team_participation == false
                @participator = @event.individual_participators
           else
                @participator = @event.team_participators
           end
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
    @event = Event.find(params[:id])
    @user = current_user
    redirect_to(@event) unless @event.administrators.include?(@user)
  end

end
