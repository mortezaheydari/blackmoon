class EventsController < ApplicationController
  include SessionsHelper
 	before_filter :authenticate_account!, only: [:new, :create, :edit, :destroy, :like]
 	before_filter :user_must_be_admin?, only: [:edit, :destroy]

  @model_name = "Event"

  include Liking
    # like
    # like_card

  include OfferingConcern
    # index
    # new
    # create
    # destroy
    # show
    # edit
    # update

##Liking
#  def like
#    @event = Event.find(params[:id])
#
#    if current_user.flagged?(@event, :like)
#      current_user.unflag(@event, :like)
#      msg = "you now don't like this event."
#    else
#      current_user.flag(@event, :like)
#      msg = "you now like this event."
#    end
#    respond_to do |format|
#        format.html { redirect_to @event}
#        format.js
#    end
#  end
#
#  def like_cards
#    @event = Event.find(params[:id])
#
#    # current_user.unflag(@event, :like)
#    current_user.toggle_flag(@event, :like)
#    respond_to do |format|
#        format.js { render 'shared/offering/like_cards', :locals => { offering: @event, style_id: params[:style_id], class_name: params[:class_name] } }
#    end
#  end
#

## OfferingConcern
#  def index
#    @events = Event.all
#    @recent_activities =  PublicActivity::Activity.where(trackable_type: "Event")
#    @recent_activities = @recent_activities.order("created_at desc")
#  end
#
#  def new
#  	@event = Event.new
#    @event.happening_case = HappeningCase.new
#    @date_and_time = Time.now
#  end
#
#  def create
#    @current_user_id = current_user.id
#    @event = Event.new(params[:event])
#    @event.team_participation ||= false
#    @event.album = Album.new
#
#    # here, location assignment operation should take place.
#
#    if @event.save
#      # @event.happening_case.save
#      params[:happening_case][:date_and_time] = date_helper_to_str(params[:date_and_time])
#      @event.create_happening_case(params[:happening_case])
#      @event.create_activity :create, owner: current_user
#      @event.create_offering_creation(creator_id: @current_user_id)
#      @event.offering_administrations.create(administrator_id: @current_user_id)
#      redirect_to @event, notice: "Event was created"
#    else
#      redirect_to new_event_path, notice: "there has been a problem with data entry."
#    end
#  end
#
#  def destroy
#  	@user = current_user
#  	@event = Event.find(params[:id])
#    if user_is_admin?(@event) && user_created_this?(@event)
#      @event.create_activity :destroy, owner: current_user
#			@event.destroy
#			# @event.offering_creation.destroy
#      # @event.offering_administrations.destroy
#  		redirect_to @event
#  	else
#  		render 'index'
#  	end
#  end
#
#  def show
#  	@event = Event.find(params[:id])
#    @likes = @event.flaggings.with_flag(:like)
#    @photo = Photo.new
#    @album = @event.album
#    @owner = @event
#    @recent_activities =  PublicActivity::Activity.where(trackable_type: "Event", trackable_id: @event.id)
#    @recent_activities = @recent_activities.order("created_at desc")
#    # flaggings.each do |flagging|
#    #      @likes = []
#    #      @likes << flagging.flagger
#    # end
#    if @event.team_participation == false
#        @participator = @event.individual_participators
#    else
#        @participator = @event.team_participators
#    end
#
#  end
#
#  def edit
#        @event = Event.find(params[:id])
#        @date_and_time = @event.happening_case.date_and_time
#        @event.album ||= Album.new
#        @photo = Photo.new
#        @photo.title = "Logo"
#  end
#
#  def update
#    @event = Event.find(params[:id])
#
#    # @event.date_and_time = date_helper_to_str(params[:date_and_time])
#    params[:happening_case][:date_and_time] = date_helper_to_str(params[:date_and_time])
#    if @event.update_attributes(params[:event])  && @event.happening_case.update_attributes(params[:happening_case])
#      @event.create_activity :update, owner: current_user
#      redirect_to @event, notice: "Event was updated"
#    else
#      render 'edit'
#    end
#	end
#
#  def user_must_be_admin?
#    @event = Event.find(params[:id])
#    @user = current_user
#    redirect_to(@event) unless @event.administrators.include?(@user)
#  end

end
