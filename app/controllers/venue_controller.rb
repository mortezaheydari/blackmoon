class VenueController < ApplicationController

  include SessionsHelper
  before_filter :authenticate_account!, only: [:new, :create, :edit, :destroy, :like]
  before_filter :user_must_be_admin?, only: [:edit, :destroy]

  include PublicActivity::Model

  def like
    @venue = Venue.find(params[:id])

    if current_user.flagged?(@venue, :like)
      current_user.unflag(@venue, :like)
      msg = "you now don't like this venue."
    else
      current_user.flag(@venue, :like)
      msg = "you now like this venue."
    end
    respond_to do |format|
        format.html { redirect_to @venue}
        format.js
    end
  end

  def like_cards
    @venue = Venue.find(params[:id])

    # current_user.unflag(@venue, :like)
    current_user.toggle_flag(@venue, :like)
    respond_to do |format|
        format.js { render 'shared/offering/like_cards', :locals => { offering: @venue, style_id: params[:style_id], class_name: params[:class_name] } }
    end
  end

  def index
    @venues = Venue.all
    @recent_activities = PublicActivity::Activity.where(trackable_type: "Venue")
    @recent_activities = @recent_activities.order("created_at desc")    
  end

  def new
    @venue = Venue.new
    @venue.happening_case = HappeningCase.new
    @venue.location = Location.new
  end


  def create
    @current_user_id = current_user.id
    @venue = Venue.new(params[:venue])
    @venue.album = Album.new
    @venue.location = Location.new(params[:location])

    # here, location assignment operation should take place.

    if @venue.save
      # @venue.happening_case.save
      params[:happening_case][:date_and_time] = date_helper_to_str(params[:date_and_time])
      @venue.create_activity :create, owner: current_user
      @venue.create_offering_creation(creator_id: @current_user_id)
      @venue.offering_administrations.create(administrator_id: @current_user_id)
      redirect_to @venue, notice: "Venue was created"
    else
      redirect_to new_venue_path, notice: "There has been a problem with data entry."
    end
  end  

  def destroy
    @user = current_user
    @venue = Venue.find(params[:id])
    if user_is_admin?(@venue) && user_created_this?(@venue)
      @venue.create_activity :destroy, owner: current_user
      @venue.destroy
      # @venue.offering_creation.destroy
      # @venue.offering_administrations.destroy
      redirect_to @venue
    else
      render 'index'
    end
  end

  def show
    @venue = Venue.find(params[:id])
    @likes = @venue.flaggings.with_flag(:like)
    @photo = Photo.new
    @album = @venue.album
    @owner = @venue
    @location = @venue.location    
    @recent_activities =  PublicActivity::Activity.where(trackable_type: "Venue", trackable_id: @venue.id)
    @recent_activities = @recent_activities.order("created_at desc")
    # flaggings.each do |flagging|
    #      @likes = []
    #      @likes << flagging.flagger
    # end

  end

  def edit
    @venue = Venue.find(params[:id])
    @venue.album ||= Album.new
    @location = @venue.location
    @photo = Photo.new
    @photo.title = "Logo"
  end

  def update
    @venue = Venue.find(params[:id])

    if @venue.update_attributes(params[:venue])
      @venue.create_activity :update, owner: current_user
      redirect_to @venue, notice: "Venue was updated"
    else
      render 'edit'
    end
  end

  def user_must_be_admin?
    @venue = Venue.find(params[:id])
    @user = current_user
    redirect_to(@venue) unless @venue.administrators.include?(@user)
  end

end
