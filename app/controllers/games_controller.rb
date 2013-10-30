class GamesController < ApplicationController
  include SessionsHelper
 	before_filter :authenticate_account!, only: [:new, :create, :edit, :destroy, :like]
 	before_filter :user_must_be_admin?, only: [:edit, :destroy]

#  @model_name = "Game"
#
#  include Liking
#    # like
#    # like_card

#  include OfferingConcern
#    # index
#    # new
#    # create
#    # destroy
#    # show
#    # edit
#    # update

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
    @date_and_time = Time.now
      
    
  end

  def create
    @current_user_id = current_user.id
    @game = Game.new(params[:game])
    @game.team_participation ||= false
    @game.album = Album.new

    
      double_check(new_game_path, "there has been a problem with data entry.") {
    @game.save }

    params[:happening_case][:date_and_time] = date_helper_to_str(params[:date_and_time])

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
    @date_and_time = @game.happening_case.date_and_time
    @game.album ||= Album.new
    @photo = Photo.new
    @photo.title = "Logo"
    
  end

  def update
    @game = Game.find(params[:id])

    # @game.date_and_time = date_helper_to_str(params[:date_and_time])
    params[:happening_case][:date_and_time] = date_helper_to_str(params[:date_and_time])

    

      double_check(edit_game_path(@game)) {
    @game.update_attributes(params[:game]) }

    @game.create_activity :update, owner: current_user

    
    redirect_to @game, notice: "Game was updated"
  end


## OfferingConcern
#  def index
#    @games = Game.all
#    @recent_activities =  PublicActivity::Activity.where(trackable_type: "Game")
#    @recent_activities = @recent_activities.order("created_at desc")
#  end
#
#  def new
#  	@game = Game.new
#    @game.happening_case = HappeningCase.new
#           @date_and_time = Time.now
#
#  end
#
#  def create
#    @current_user_id = current_user.id
#    @game = Game.new(params[:game])
#    @game.team_participation ||= false
#    @game.album = Album.new
#    if @game.save
#      params[:happening_case][:date_and_time] = date_helper_to_str(params[:date_and_time])
#      @game.create_happening_case(params[:happening_case])
#      @game.create_activity :create, owner: current_user
#      @game.create_offering_creation(creator_id: @current_user_id)
#      @game.offering_administrations.create(administrator_id: @current_user_id)
#      redirect_to @game
#    else
#      redirect_to new_game_path, notice: "there has been a problem with data entry."
#    end
#  end
#
#  def destroy
#  	@user = current_user
#  	@game = Game.find(params[:id])
#    if user_is_admin?(@game) && user_created_this?(@game)
#      @game.create_activity :destroy, owner: current_user
#			@game.destroy
#			# @game.offering_creation.destroy
#      # @game.offering_administrations.destroy
#  		redirect_to @game
#  	else
#  		render 'index'
#  	end
#  end
#
#  def show
#  	@game = Game.find(params[:id])
#    @likes = @game.flaggings.with_flag(:like)
#    @photo = Photo.new
#    @album = @game.album
#    @owner = @game
#    @recent_activities =  PublicActivity::Activity.where(trackable_type: "Game", trackable_id: @game.id)
#    @recent_activities = @recent_activities.order("created_at desc")
#    # flaggings.each do |flagging|
#    #      @likes = []
#    #      @likes << flagging.flagger
#    # end
#    if @game.team_participation == false
#        @participator = @game.individual_participators
#    else
#        @participator = @game.team_participators
#    end
#  end
#
#  def edit
#        @game = Game.find(params[:id])
#        @date_and_time = @game.happening_case.date_and_time
#        @game.album ||= Album.new
#        @photo = Photo.new
#        @photo.title = "Logo"
#    end
#
#  def update
#    @game = Game.find(params[:id])
#
#    # @game.date_and_time = date_helper_to_str(params[:date_and_time])
#    params[:happening_case][:date_and_time] = date_helper_to_str(params[:date_and_time])
#    if @game.update_attributes(params[:game])
#      @game.create_activity :update, owner: current_user
#      redirect_to @game, notice: "Game was updated"
#    else
#      render 'edit'
#    end
#  end
#
#  def user_must_be_admin?
#    @game = Game.find(params[:id])
#    @user = current_user
#    redirect_to(@game) unless @game.administrators.include?(@user)
#  end

end
