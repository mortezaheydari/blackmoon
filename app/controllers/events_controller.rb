class EventsController < ApplicationController
  include SessionsHelper
 	before_filter :authenticate_account!, only: [:new, :create, :edit, :destroy, :like]
 	before_filter :user_must_be_admin?, only: [:edit, :destroy]

            add_breadcrumb "home", :root_path
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
        format.js { render 'shared/offering/like_cards', :locals => { offering: @event, style_id: params[:style_id], class_name: params[:class_name] } }
    end
  end

  def index
    add_breadcrumb "events", events_path, :title => "Back to the Index"
    @events = Event.all
    @recent_activities =  PublicActivity::Activity.where(trackable_type: "Event")
    @recent_activities = @recent_activities.order("created_at desc")

  end

  def new
    @event = Event.new
    @event.happening_case = HappeningCase.new
    @happening_case = @event.happening_case

  end

  def create
    @current_user_id = current_user.id
    @event = Event.new(params[:event])
    @event.team_participation ||= false
    @event.album = Album.new


      return unless double_check(new_event_path, "there has been a problem with data entry.") {
    @event.save }

    @event.create_happening_case(params[:happening_case])
    @event.create_activity :create, owner: current_user
    @event.create_offering_creation(creator_id: @current_user_id)
    @event.offering_administrations.create(administrator_id: @current_user_id)


    redirect_to @event
  end

  def destroy
    @user = current_user
    @event = Event.find(params[:id])


      return unless double_check(events_path) {
    user_is_admin?(@event) && user_created_this?(@event) }

    @event.create_activity :destroy, owner: current_user

      return unless double_check(@event) {
    @event.destroy }

    redirect_to(events_path)
  end

  def show
    @event = Event.find(params[:id])
    add_breadcrumb "events", events_path, :title => "Back to the Index"
    add_breadcrumb @event.title, event_path(@event)
    @likes = @event.flaggings.with_flag(:like)
    @photo = Photo.new
    @album = @event.album
    @owner = @event
    @recent_activities =  PublicActivity::Activity.where(trackable_type: "Event", trackable_id: @event.id)
    @recent_activities = @recent_activities.order("created_at desc")

    if @event.team_participation == false
      @participator = @event.individual_participators
    else
      @participator = @event.team_participators
    end

  end

  def edit
    @event = Event.find(params[:id])
    @happening_case = @event.happening_case
    @event.album ||= Album.new
    @photo = Photo.new
    @photo.title = "Logo"

  end

  def update
    @event = Event.find(params[:id])

      return unless double_check(edit_event_path(@event)) {
    @event.update_attributes(params[:event]) }
      return unless double_check(edit_event_path(@event)) {
    @event.happening_case.update_attributes params[:happening_case] }
      return unless double_check(edit_event_path(@event)) {
    @event.create_activity :update, owner: current_user }


    redirect_to @event, notice: "Event was updated"
  end

   def user_must_be_admin?
     @event = Event.find(params[:id])
     @user = current_user
     redirect_to(@event) unless @event.administrators.include?(@user)
   end

end
