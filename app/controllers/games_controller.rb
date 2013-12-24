class GamesController < ApplicationController
	include SessionsHelper
	before_filter :can_create, only: [:create]
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
		@search = Sunspot.search(Game) do
			fulltext params[:search]

			facet(:sport)
			with(:sport, params[:sport]) if params[:sport].present?

			facet(:city)
			with(:city, params[:city]) if params[:city].present?

			facet(:gender)
			with(:gender, params[:gender]) if params[:gender].present?

			order_by(:updated_at, :desc)

			if params[:team_participation]  == "checked"
				with(:team_participation, true)
			end

		end
		@games = @search.results

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

	def create
		# variables and params assignment
		@venues = Venue.all		
		@current_user_id = current_user.id
		set_params_gmaps_flag :game
		location_param = params[:game].delete :location

		@game = Game.new(safe_param)

		@game.album = Album.new
		@happening_case = @game.build_happening_case(params[:happening_case])

		# # gender
		# if ["male", "female"].include? @game.gender
		#   unless current_user.gender == @game.gender; raise Errors::FlowError.new(root_path, "This game is #{@game.gender} only."); end
		# end

		@location = @game.build_location(location_param)

		# custom or referenced location.
		if params[:location_type] == "parent_location"
			referenced_location = venue_location(params[:referenced_venue_id])
			if !referenced_location; raise Errors::FlowError.new(new_game_path, "location was not valid"); end
			copy_locations(referenced_location, @game.location)
			@game.location.parent_id = referenced_location.id
		else
			@game.location.parent_id = nil
		end

		# validation and assignment
		if @game.location.invalid? ; raise Errors::ValidationError.new(:new, ["Address is not valid."]); end
		if @game.happening_case.invalid? ; raise Errors::ValidationError.new(:new, @game.happening_case.errors); end
		if @game.invalid? ; raise Errors::ValidationError.new(:new, @game.errors); end

		if !@game.save ; raise Errors::FlowError.new(new_game_path, @game.errors); end

		# secondary database actions
		unless @game.create_offering_creation(creator_id: @current_user_id)
			@game.destroy
			raise Errors::LoudMalfunction.new("E0801")
		end
		unless @game.offering_administrations.create(administrator_id: @current_user_id)
			@game.destroy
			raise Errors::LoudMalfunction.new("E0802")
		end	
		unless @game.create_activity(:create, owner: current_user)
			silent_malfunction_error_handler("E0803")		
		end

		# done 
		redirect_to @game, notice: "Game was created"
	end

	def destroy
		@user = current_user
		@game = Game.find(params[:id])

		unless user_is_admin?(@game) && user_created_this?(@game); raise Errors::FlowError.new(games_path, "Permission denied."); end

		if !@game.destroy; raise Errors::FlowError.new(@game); end

		@game.create_activity :destroy, owner: current_user

		redirect_to(games_path)
	end

	def show
		begin
			@game = Game.find(params[:id])
		rescue
			raise Errors::FlowError.new(games_path, "Game not found.")
		end
		add_breadcrumb "games", games_path, :title => "Back to the Index"
		add_breadcrumb @game.title, game_path(@game)
		@likes = @game.flaggings.with_flag(:like)
		@photo = Photo.new
		@album = @game.album
		if ["male", "female"].include? @game.gender
			@teams = Team.where("gender = ?", @game.gender)
		else
			@teams = Team.all
		end
		@my_teams = []
		current_user.teams_administrating.each do |team|
			unless team_is_participating?(@game, team)
				if @game.gender == team.gender
						@my_teams << team
				end
			end
		end
		@owner = @game

		if @game.location.parent_id.nil?
			@location = @game.location
		else
			@location = @game.location.parent_location
		end

		@json = @location.to_gmaps4rails
		@recent_activities =  PublicActivity::Activity.where(trackable_type: "Game", trackable_id: @game.id)
		@recent_activities = @recent_activities.order("created_at desc")

		if @game.team_participation == false
			@participator = @game.individual_participators
		else
			@participator = @game.team_participators
		end

	end

	def edit
		begin
			@game = Game.find(params[:id])
		rescue
			raise Errors::FlowError.new(games_path, "Game not found.")
		end
		@happening_case = @game.happening_case
		@game.album ||= Album.new
		@location = @game.location
		@venues = Venue.all
		@photo = Photo.new
		@photo.title = "Logo"

	end

	def update
		@game = Game.find(params[:id])
		@venues = Venue.all
		@photo = Photo.new
		@photo.title = "Logo"
		@location = @game.location
		@happening_case = @game.happening_case

		# # gender
		# if ["male", "female"].include? params[:game][:gender]
		#   unless current_user.gender == params[:game][:gender]; raise Errors::FlowError.new(root_path, "This game is #{@game.gender} only."); end
		# end

		# update location
		if changing_location_parent?(@game) || changing_location_to_parent?(@game)
			params[:game].delete :location
			referenced_location = venue_location(params[:referenced_venue_id])
			if !referenced_location; raise Errors::ValidationError.new(:edit, "Address is not valid."); end
			copy_locations(referenced_location, @game.location)
			@game.location.parent_id = referenced_location.id # change location parent
		elsif changing_location_to_custom?(@game) || changing_custom_location?(@game, :game)
			set_params_gmaps_flag :game
			location = params[:game].delete :location
			temp_location = Location.new(location)
			if temp_location.invalid?; raise Errors::ValidationError.new(:edit, "Address is not valid.");end;
			copy_locations(temp_location, @game.location)

			@game.location.parent_id = nil # change to custom
			@location = @game.location			
		else
			params[:game].delete :location
		end

		if @game.location.invalid?; raise Errors::ValidationError.new(:edit, @game.location.errors); end

		# update and validate happening_case
		@game.happening_case.assign_attributes params[:happening_case]
		if @game.happening_case.invalid?; raise Errors::ValidationError.new(:edit, @game.happening_case.errors); end

		@happening_case = @game.happening_case

		# update and validate game
		@game.assign_attributes safe_param

		if @game.invalid?; raise Errors::ValidationError.new(:edit, @game.errors); end
		if !@game.save; raise Errors::FlowError.new(:edit, @game.errors); end		

		# secondary database actions
		unless @game.create_activity :update, owner: current_user
			silent_malfunction_error_handler("E0804")	
		end
		# done
		redirect_to @game, notice: "Game was updated"

	end

	private

		def user_must_be_admin?
		 @game = Game.find(params[:id])
		 @user = current_user
		 redirect_to(@game) and return unless @game.administrators.include?(@user)
		end
		def can_create
			redirect_to root_path and return unless current_user.can_create? "game"
		end

		def safe_param
			this = Hash.new
			this[:title] = params[:game][:title] unless params[:game][:title].nil?
			this[:description] = params[:game][:description] unless params[:game][:description].nil?
			this[:category] = params[:game][:category] unless params[:game][:category].nil?
			this[:fee] = params[:game][:fee] unless params[:game][:fee].nil?
			this[:fee_type] = params[:game][:fee_type] unless params[:game][:fee_type].nil?
			this[:sport] = params[:game][:sport] unless params[:game][:sport].nil?
			this[:number_of_attendings] = params[:game][:number_of_attendings] unless params[:game][:number_of_attendings].nil?
			this[:team_participation] = params[:game][:team_participation] unless params[:game][:team_participation].nil?
			this[:open_join] = params[:game][:open_join] unless params[:game][:open_join].nil?
			this[:gender] = params[:game][:gender] unless params[:game][:gender].nil?
			this
		end

end
