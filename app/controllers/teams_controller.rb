class TeamsController < ApplicationController
	include SessionsHelper
	before_filter :can_create, only: [:create]
	before_filter :authenticate_account!, only: [:new, :create, :edit, :destroy, :like]
	before_filter :user_must_be_admin?, only: [:edit, :destroy]
			add_breadcrumb "home", :root_path

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
			format.html { redirect_to @team}
			format.js
		end
	end

	def like_cards

		@team = Team.find(params[:id])

		# current_user.unflag(@team, :like)
		current_user.toggle_flag(@team, :like)

		respond_to do |format|
			format.js { render 'shared/offering/like_team_cards', :locals => { offering: @team, style_id: params[:style_id], class_name: params[:class_name] } }
		end
	end


	def index
		add_breadcrumb "Teams", teams_path, :title => "Back to the Index"
		@search = Sunspot.search(Team) do
			fulltext params[:search]

			facet(:sport)
			with(:sport, params[:sport]) if params[:sport].present?

			facet(:gender)
			with(:gender, params[:gender]) if params[:gender].present?

			order_by(:updated_at, :desc)

			if params[:team_participation]  == "checked"
				with(:team_participation, true)
			end

		end
		@teams = @search.results

		@recent_activities =  PublicActivity::Activity.where(trackable_type: "Team")
		@recent_activities = @recent_activities.order("created_at desc")
	end

	def new
		@team = Team.new
	end

	def create
		@current_user_id = current_user.id
		@team = Team.new(safe_param)
		@team.album = Album.new

		# gender
		if ["male", "female"].include? @team.gender
			unless current_user.gender == @team.gender; raise Validation::ValidationError.new(:new, "Gender can not be #{@team.gender}."); end
		end

		if !@team.save; raise Errors::FlowError.new(new_group_training_path, @team.errors); end

		# secondary database actions
		unless @team.create_act_creation(creator_id: @current_user_id)
			@team.destroy
			raise Errors::LoudMalfunction.new("E0501")
		end
		unless @team.act_administrations.create(administrator_id: @current_user_id)
			@team.destroy
			raise Errors::LoudMalfunction.new("E0502")
		end
		unless @team.act_memberships.create(member_id: @current_user_id)
			@team.destroy
			raise Errors::LoudMalfunction.new("E0505")
		end
		unless @team.create_activity(:create, owner: current_user)
			silent_malfunction_error_handler("E0503")
		end

		# done
		redirect_to @team
	end

	def destroy
		@user = current_user
		@team = Team.find(params[:id])

		if user_is_admin?(@team) && user_created_this?(@team)
			if !@team.destroy; raise Errors::FlowError.new(@team); end
			@team.create_activity :destroy, owner: current_user

			redirect_to @team
		else
			raise Errors::FlowError.new(@team, "Permission denied."); end
		end
	end

	def show
		begin
			@team = Team.find(params[:id])
		rescue
			raise Errors::FlowError.new(teams_path, "Team not found.")
		end
		add_breadcrumb "Teams", teams_path, :title => "Back to the Index"
		add_breadcrumb @team.title, team_path(@team)
		@likes = @team.flaggings.with_flag(:like)
		@members = @team.members
		@photo = Photo.new
		@album = @team.album
		@owner = @team

		@recent_activities =  PublicActivity::Activity.where(trackable_type: "Team", trackable_id: @team.id)
		@recent_activities = @recent_activities.order("created_at desc")

		@team_notifications =  PublicActivity::Activity.where(recipient_type: "Team", recipient_id: @team.id)
		@team_notifications = @team_notifications.order("created_at desc")
	end

	def edit
		begin
			@team = Team.find(params[:id])
		rescue
			raise Errors::FlowError.new(teams_path, "Team not found.")
		end
		@team.album ||= Album.new
		@photo = Photo.new
		@photo.title = "Logo"
	end

	def update
		@team = Team.find(params[:id])
		@photo = Photo.new
		@photo.title = "Logo"

		# # gender
		# if ["male", "female"].include? params[:team][:gender]
		# 	unless current_user.gender == params[:team][:gender]; raise Errors::FlowError.new(root_path, "This team is #{@team.gender} only."); end
		# end

		# update and validate venue
		@team.assign_attributes safe_param

		if @team.invalid?; raise Errors::ValidationError.new(:edit, @team.errors); end
		if !@team.save; raise Errors::FlowError.new(:edit, @team.errors); end

		# secondary database actions
		unless @team.create_activity :update, owner: current_user
			silent_malfunction_error_handler("E0504")
		end

		# done
		redirect_to @team, notice: "Team page was updated"
	end

	private
		def user_must_be_admin?
			@team = Team.find(params[:id])
			@user = current_user
			redirect_to(@team) and return unless @team.administrators.include?(@user)
		end

		def can_create
			redirect_to root_path and return unless current_user.can_create? "team"
		end

		def safe_param
			this = Hash.new
			this[:title] = params[:team][:title] unless params[:team][:title].nil?
			this[:descreption] = params[:team][:descreption] unless params[:team][:descreption].nil?
			this[:sport] = params[:team][:sport] unless params[:team][:sport].nil?
			this[:number_of_attendings] = params[:team][:number_of_attendings] unless params[:team][:number_of_attendings].nil?
			this[:category] = params[:team][:category] unless params[:team][:category].nil?
			this[:open_join] = params[:team][:open_join] unless params[:team][:open_join].nil?
			this[:gender] = params[:team][:gender] unless params[:team][:gender].nil?
			this
		end
end

