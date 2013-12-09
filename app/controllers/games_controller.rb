class GamesController < ApplicationController
  include SessionsHelper
 	before_filter :authenticate_account!, only: [:new, :create, :edit, :destroy, :like]
 	before_filter :user_must_be_admin?, only: [:edit, :destroy]

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


      double_check(new_game_path, "there has been a problem with data entry.") {
    @game.save }

    @game.create_happening_case(params[:happening_case])
    @game.create_activity :create, owner: current_user
    @game.create_offering_creation(creator_id: @current_user_id)
    @game.offering_administrations.create(administrator_id: @current_user_id)


    redirect_to @game
  end

  def destroy
    @user = current_user
    @game = Game.find(params[:id])


      double_check(games_path) {
    user_is_admin?(@game) && user_created_this?(@game) }

    @game.create_activity :destroy, owner: current_user

      double_check(@game) {
    @game.destroy }

    redirect_to(games_path)
  end

  def show
    @game = Game.find(params[:id])
    @likes = @game.flaggings.with_flag(:like)
    @photo = Photo.new
    @album = @game.album
    @owner = @game
    @recent_activities =  PublicActivity::Activity.where(trackable_type: "Game", trackable_id: @game.id)
    @recent_activities = @recent_activities.order("created_at desc")
    # flaggings.each do |flagging|
    #      @likes = []
    #      @likes << flagging.flagger
    # end
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

      double_check(edit_game_path(@game)) {
    @game.update_attributes(params[:game]) }
      double_check(edit_game_path(@game)) {
    @game.happening_case.update_attributes params[:happening_case] }
      double_check(edit_game_path(@game)) {
    @game.create_activity :update, owner: current_user }

    redirect_to @game, notice: "Game was updated"
  end
  
  private

    def user_must_be_admin?
     @game = Game.find(params[:id])
     @user = current_user
     redirect_to(@game) unless @game.administrators.include?(@user)
    end

end
