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

    if !@game.save ; raise Errors::FlowError.new(new_game_path, "there has been a problem with data entry."); end

    @game.create_activity :create, owner: current_user
    @game.offering_administrations.create(administrator_id: @current_user_id)


    redirect_to @game
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
