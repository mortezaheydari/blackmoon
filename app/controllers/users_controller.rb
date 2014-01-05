class UsersController < ApplicationController
	before_filter :authenticate_account!, only: [:edit, :update]
            include SessionsHelper
	include MultiSessionsHelper

    add_breadcrumb "home", :root_path
	def index
		@users = User.all
	end

	def show
		begin
			@user = User.find(params[:id])
		rescue
			raise Errors::FlowError.new(users_path, "User not found.")
		end
        add_breadcrumb @user.title, user_path(@user)
		@likes = @user.flaggings.with_flag(:like)
		@photo = Photo.new
		@album = @user.album
	end

	def edit
		begin
			@user = User.find(params[:id])
		rescue
			raise Errors::FlowError.new(users_path, "User not found.")
		end
		@user.profile ||= Profile.new
		@user.album ||= Album.new
		@photo = Photo.new
		@photo.title = "Logo"
		@date_of_birth = @user.profile.date_of_birth
	end

	def update
		params_striper
		@user = User.find(params[:id])
        @photo = Photo.new
        @photo.title = "Logo"

        @date_of_birth = @user.profile.date_of_birth
		raise Errors::FlowError.new unless current_user == @user
		@user.profile.date_of_birth = date_helper_to_str(params[:date_of_birth])
		@user.assign_attributes safe_param		
		debugger
		if @user.invalid?; raise Errors::ValidationError.new(:edit, @user.errors); end 
		unless @user.save; raise Errors::FlowError.new(@user); end 		

		flash[:success] = "Profile updated"
		redirect_to @user
	end

	def offering_management
		@user = User.find(params[:id])
		@events = @user.events_administrating
		@games = @user.games_administrating
		@teams = @user.teams_administrating
        @personal_trainers = @user.personal_trainers_administrating
        @group_trainings = @user.group_trainings_administrating
        @venues = @user.venues_administrating
	end

    def schedule
        @user = User.find(params[:id])
        # @schedule = @user.happening_schedules
        @schedule = HappeningSchedule.where("user_id = ?", @user.id)
        @grouped_happening_cases = grouped_happening_cases_for_schedule(@schedule)
        @grouped_sessions = replace_with_happening(@grouped_happening_cases)
        @date = params[:date] ? Date.parse(params[:date]) : Date.today
        @collectives = ["event","game", "user", "team", "venue", "personal_trainer", "group_training"]
    end

    private
		# make sure moonactor_ability was not passed trough params.
	    def params_striper
	    	params[:user].delete :moonactor_ability
	    end

	    def safe_param
			this = Hash.new
			Rails.logger.warn '-'*40
			Rails.logger.warn params.inspect
			this[:name] = params[:user][:name] unless params[:user][:name].nil?
			this[:gender] = params[:user][:gender] unless params[:user][:gender].nil?
			this[:profile_attributes][:first_name] = params[:user][:profile_attributes][:first_name] unless params[:user][:profile_attributes][:first_name].nil?			
			this[:profile_attributes][:last_name] = params[:user][:profile_attributes][:last_name] unless params[:user][:profile_attributes][:last_name].nil?	
			this[:profile_attributes][:phone] = params[:user][:profile_attributes][:phone] unless params[:user][:profile_attributes][:phone].nil?	
			this
		end
end
