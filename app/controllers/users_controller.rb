class UsersController < ApplicationController
	before_filter :authenticate_account!, only: [:edit, :update]
	include SessionsHelper

	def index
		@users = User.all
	end

	def show
		@user = User.find(params[:id])
		@likes = @user.flaggings.with_flag(:like)
		@photo = Photo.new
		@album = @user.album
	end

	def edit
		@user = User.find(params[:id])
		double_check { current_user == @user }		

		@user.profile ||= Profile.new
		@user.album ||= Album.new
		@photo = Photo.new
		@photo.title = "Logo"
		@date_of_birth = @user.profile.date_of_birth
	end

	def update
		@user = User.find(params[:id])
		double_check { current_user == @user }
		@user.profile.date_of_birth = date_helper_to_str(params[:date_of_birth])
		if @user.update_attributes(params[:user])
			flash[:success] = "Profile updated"
			redirect_to @user, notice: "i don't know"
		else
			render 'edit'
		end

	end

	def offering_management
		@user = User.find(params[:id])
		@events = @user.events_administrating
		@games = @user.games_administrating
		@teams = @user.teams_administrating
	end

end
