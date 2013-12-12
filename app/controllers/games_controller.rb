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
  end

  def create
    @current_user_id = current_user.id
    @game = Game.new(params[:game])
    @game.team_participation ||= false
    @game.album = Album.new
    @game.happening_case = HappeningCase.new(params[:happening_case])
    @game.create_happening_case(params[:happening_case])

    # double_check(new_game_path, "there has been a problem with data entry.") {
    if !@game.save ; raise Errors::FlowError.new(new_game_path, "there has been a problem with data entry."); end

    @game.create_activity :create, owner: current_user
    @game.offering_administrations.create(administrator_id: @current_user_id)


    redirect_to @game
  end

  def destroy
    @user = current_user
    @game = Game.find(params[:id])


      return unless double_check(games_path) {
    user_is_admin?(@game) && user_created_this?(@game) }

    @game.create_activity :destroy, owner: current_user

      return unless double_check(@game) {
    @game.destroy }

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
    @photo = Photo.new
    @photo.title = "Logo"

  end

  def update
    @game = Game.find(params[:id])

      return unless double_check(edit_game_path(@game)) {
    @game.update_attributes(params[:game]) }
      return unless double_check(edit_game_path(@game)) {
    @game.happening_case.update_attributes params[:happening_case] }
      return unless double_check(edit_game_path(@game)) {
    @game.create_activity :update, owner: current_user }

    redirect_to @game, notice: "Game was updated"
  end

  private

    def user_must_be_admin?
     @game = Game.find(params[:id])
     @user = current_user
     redirect_to(@game) unless @game.administrators.include?(@user)
    end

##TODO: determine if the following works


  def name_is_valid?(name)
    ["event","class","game", "user", "team", "venue"].include? name.underscore
  end

  def double_check_name_is_valid(user, name)
    return false unless double_check(root_path, 'permission error: name is not valid!') {
      name_is_valid?(user, name) }
  end

  # find and assign, dose it without administration check,
  # whereas this_if_reachable might also consider (this.administrators.include? current_user).

  def find_and_assign this_type, this_id

    if ["user", "team", "event", "game", "venue", "offering_session"].include? this_type.underscore and this_id
      this_type.camelize.constantize.find_by_id(this_id)
    else
      nil
    end
  end

  def this_if_reachable(this_type, this_id)
    unless this_type == "Collective"
      return false unless double_check_name_is_valid?(this_type)
    end
    this = this_type.constantize.find(this_id)
    return false unless double_check { this }
        this
  end

  def owner_if_reachable(this_type, this_id)
    this = this_if_reachable(this_type, this_id)
    return false unless double_check { this }
    if this_type == "Collective"
      return false unless double_check { this.owner.administrators.include? current_user }
    else
      return false unless double_check { this.administrators.include? current_user }
    end
    this
  end

  # My Bloodthirsty double_check method, version-20131023
  def double_check(link=root_path, msg='there was an error with your request', &b)
    link == @redirect_object unless @redirect_object.nil?
    redirect_to(link, alert: msg) and return unless b.call
  end
  # -ended







end
