class TeamsController < ApplicationController
  include SessionsHelper
 	before_filter :authenticate_account!, only: [:new, :create, :edit, :destroy, :like]
 	before_filter :user_must_be_admin?, only: [:edit, :destroy]

  def like
    @team = Team.find(params[:id])

    if current_user.flagged?(@team, :like)
      current_user.unflag(@team, :like)
      msg = "you now don't like this team."
    else
      current_user.flag(@team, :like)
      msg = "you now like this team."
    end
    respond_to do |format|
        format.html { redirect_to @team, notice: msg }
        format.js
    end
  end

  def like_cards
    @team = Team.find(params[:id])

    # current_user.unflag(@team, :like)
    current_user.toggle_flag(@team, :like)
    respond_to do |format|
        format.js
    end
  end

  def index
    @teams = Team.all
  end

  def new
  	@team = Team.new
  end

  def create
    @current_user_id = current_user.id
  	@team = Team.new(params[:team])
    @team.album = Album.new
    @team.save
  	@team.create_act_creation(creator_id: @current_user_id)
    @team.act_administrations.create(administrator_id: @current_user_id)
    @team.act_memberships.create(member_id: @current_user_id)
    # activities
      
      @team.create_activity :create, owner: current_user, recipient: @team
      @team.create_activity :create, owner: current_user, recipient_type "User"
    # # #
		redirect_to @team
  end

  def destroy
  	@user = current_user
  	@team = Team.find(params[:id])
		if user_is_admin?(@team) && user_created_this?(@team)
			@team.destroy
      # activities    
        @team.create_activity :destroy, owner: current_user, recipient: @team
        @team.create_activity :destroy, owner: current_user, recipient_type: "User"
      # # #

			# @team.offering_creation.destroy
      # @team.offering_administrations.destroy
  		redirect_to @team
  	else
  		render 'index'
  	end
  end

  def show
  	@team = Team.find(params[:id])
		@likes = @team.flaggings.with_flag(:like)
		@members = @team.members
    @photo = Photo.new
    @album = @team.album
    @owner = @team
  end

  def edit
    @team = Team.find(params[:id])
    @team.album ||= Album.new
    @photo = Photo.new
    @photo.title = "Logo"
  end

  def update
    @team = Team.find(params[:id])
    if @team.update_attributes(params[:team])
      # activities    
        @team.create_activity :update , owner: current_user, recipient: @team
        @team.create_activity :update , owner: current_user, recipient_type: "User"
      # # #
      redirect_to @team
    else
      render 'edit'
    end
	end

  def user_must_be_admin?
    @team = Team.find(params[:id])
    @user = current_user
    redirect_to(@team) unless @team.administrators.include?(@user)
  end

end
