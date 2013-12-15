class GamesController < ApplicationController
  include SessionsHelper
 	before_filter :authenticate_account!, only: [:new, :create, :edit, :destroy, :like]
 	before_filter :user_must_be_admin?, only: [:edit, :destroy]

            add_breadcrumb "home", :root_path
  def like

    @game = Game.find(params[:id])

    if current_user.flagged?(@game, :like)
      current_user.unflag(@game, :like)
      msg = "you now don't like this game."
    else
      current_user.flag(@game, :like)
      msg = "you now like this game."
    end

    respond_to do |format|
        format.html { redirect_to @game}
        format.js
    end
  end

  def like_cards

    @game = Game.find(params[:id])

    # current_user.unflag(@game, :like)
    current_user.toggle_flag(@game, :like)

    respond_to do |format|
        format.js { render 'shared/offering/like_cards', :locals => { offering: @game, style_id: params[:style_id], class_name: params[:class_name] } }
    end
  end

  def index
    add_breadcrumb "games", games_path, :title => "Back to the Index"
    @games = Game.all
    @recent_activities =  PublicActivity::Activity.where(trackable_type: "Game")
    @recent_activities = @recent_activities.order("created_at desc")

  end

  def new
    @game = Game.new
    @game.happening_case = HappeningCase.new
    @happening_case = @game.happening_case
    @venues = Venue.all
    @location = Location.new
  end

  # TODO: procedure order to be used in other controllers.
  def create
    @current_user_id = current_user.id
    set_params_gmaps_flag :game
    location = params[:game].delete :location
    @game = Game.new(params[:game])
    @game.team_participation ||= false
    @game.album = Album.new
    @game.happening_case = HappeningCase.new(params[:happening_case])


    @game.build_location(location)

    # custom or referenced location.
    if params[:location_type] == "parent_location"
      referenced_location = venue_location(params[:referenced_venue_id])
      if !referenced_location; raise Errors::FlowError.new(new_game_path, "location not valid"); end
      copy_locations(referenced_location, @game.location)
      @game.location.parent_id = referenced_location.id
    else
      @game.location.parent_id = nil
    end

    # here, location assignment operation should take place.

    if !@game.save ; raise Errors::FlowError.new(new_game_path, "there has been a problem with data entry."); end

    @game.create_offering_creation(creator_id: @current_user_id)
    @game.offering_administrations.create(administrator_id: @current_user_id)
    @game.create_activity :create, owner: current_user

    redirect_to @game, notice: "Game was created"
  end

  def destroy
    @user = current_user
    @game = Game.find(params[:id])

    unless user_is_admin?(@game) && user_created_this?(@game); raise Errors::FlowError.new(games_path); end

    @game.create_activity :destroy, owner: current_user

    if !@game.destroy; raise Errors::FlowError.new(@game); end

    redirect_to(games_path)
  end

  def show
    @game = Game.find(params[:id])
    add_breadcrumb "games", games_path, :title => "Back to the Index"
    add_breadcrumb @game.title, game_path(@game)
    @likes = @game.flaggings.with_flag(:like)
    @photo = Photo.new
    @album = @game.album
    @owner = @game
    @location = @game.location if @game.location
    if @location
        @json = @game.location.to_gmaps4rails
    end
    @recent_activities =  PublicActivity::Activity.where(trackable_type: "Game", trackable_id: @game.id)
    @recent_activities = @recent_activities.order("created_at desc")

    if @game.team_participation == false
      @participator = @game.individual_participators
    else
      @participator = @game.team_participators
    end

  end

  def edit
    @game = Game.find(params[:id])
    @happening_case = @game.happening_case
    @game.album ||= Album.new
    @location = @game.location
    @venues = Venue.all
    @photo = Photo.new
    @photo.title = "Logo"

  end

  def update
    @game = Game.find(params[:id])

    # update location
    if changing_location_parent?(@game) || changing_location_to_parent?(@game)
      params[:game].delete :location
      referenced_location = venue_location(params[:referenced_venue_id])
      if !referenced_location; raise Errors::FlowError.new(new_game_path, "location not valid"); end
      copy_locations(referenced_location, @game.location)
      @game.location.parent_id = referenced_location.id
      # change location parent
    elsif changing_location_to_custom?(@game) || changing_custom_location?(@game)
      set_params_gmaps_flag :game
      location = params[:game].delete :location
      temp_location = Location.new(location)
      copy_locations(temp_location, @game.location)
      if @game.location.invalid?
        errors = "Location invalid. "
        @game.location.errors.each { |m| errors +=  (m.first.to_s + ": " + m.last.first.to_s + "; ") }
        raise Errors::FlowError.new(edit_game_path(@game), errors)
      end
      @game.location.parent_id = nil
      # change to custom
    else
      params[:game].delete :location
      # do nothing
    end

    if !@game.update_attributes(params[:game]); raise Errors::FlowError.new(edit_game_path(@game)); end
    if !@game.happening_case.update_attributes params[:happening_case]; raise Errors::FlowError.new(edit_game_path(@game)); end
    if !@game.create_activity :update, owner: current_user; raise Errors::FlowError.new(edit_game_path(@game)); end

    redirect_to @game, notice: "Game was updated"
  end

  private

    def user_must_be_admin?
     @game = Game.find(params[:id])
     @user = current_user
     redirect_to(@game) unless @game.administrators.include?(@user)
    end


end
