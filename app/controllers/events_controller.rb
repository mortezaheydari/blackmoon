class EventsController < ApplicationController
	include SessionsHelper
	before_filter :can_create, only: [:create]	
	before_filter :authenticate_account!, only: [:new, :create, :edit, :destroy, :like]
	before_filter :user_must_be_admin?, only: [:edit, :destroy]

	add_breadcrumb "home", :root_path
	def like

		@event = Event.find(params[:id])

		if current_user.flagged?(@event, :like)
			current_user.unflag(@event, :like)
			msg = "you now don't like this event."
		else
			current_user.flag(@event, :like)
			msg = "you now like this event."
		end

		respond_to do |format|
			format.html { redirect_to @event}
			format.js
		end
	end

	def like_cards

		@event = Event.find(params[:id])

		# current_user.unflag(@event, :like)
		current_user.toggle_flag(@event, :like)

		respond_to do |format|
				format.js { render 'shared/offering/like_cards', :locals => { offering: @event, style_id: params[:style_id], class_name: params[:class_name] } }
		end
	end

	def index
		add_breadcrumb "events", events_path, :title => "Back to the Index"

		@search = Sunspot.search(Event) do
			fulltext params[:search]

			# with(:price, params[:min_price].to_i..params[:max_price].to_i) if params[:max_price].present? && params[:min_price].present?
			# with(:price).greater_than(params[:min_price].to_i) if !params[:max_price].present? && params[:min_price].present?
			# with(:price).less_than(params[:max_price].to_i) if params[:max_price].present? && !params[:min_price].present?

			# with(:condition, params[:condition]) if params[:condition].present?
			facet(:sport)
			with(:sport, params[:sport]) if params[:sport].present?

			facet(:city)
			with(:city, params[:city]) if params[:city].present?

			facet(:gender)
			with(:gender, params[:gender]) if params[:gender].present?

			order_by(:updated_at, :desc)
			# if params[:order_by] == "Price"
			#   order_by(:price)
			# elsif params[:order_by] == "Popular"
			#   order_by(:favorite_count, :desc)
			# end

			if params[:team_participation]  == "checked"
				with(:team_participation, true)
			end

		end
		@events = @search.results

		@recent_activities =  PublicActivity::Activity.where(trackable_type: "Event")
		@recent_activities = @recent_activities.order("created_at desc")

	end

	def new
		@event = Event.new
		@event.happening_case = HappeningCase.new
		@happening_case = @event.happening_case
		@venues = Venue.all
		@location = Location.new
	end

	def create
		@venues = Venue.all		
		@current_user_id = current_user.id
		set_params_gmaps_flag :event
		location_param = params[:event].delete :location

		@event = Event.new(safe_param)

		@event.album = Album.new
		@happening_case = @event.happening_case = HappeningCase.new(params[:happening_case])

		# # gender
		# if ["male", "female"].include? @event.gender
		#   unless current_user.gender == @event.gender; raise Errors::FlowError.new(root_path, "This event is #{@event.gender} only."); end
		# end

		@location = @event.build_location(location_param)

		# custom or referenced location.
		if params[:location_type] == "parent_location"
			referenced_location = venue_location(params[:referenced_venue_id])
			if !referenced_location; raise Errors::FlowError.new(new_event_path, "location was not valid"); end
			copy_locations(referenced_location, @event.location)
			@event.location.parent_id = referenced_location.id
		else
			@event.location.parent_id = nil
		end

		# validation and assignment
		if @event.location.invalid? ; raise Errors::ValidationError.new(:new, ["Address is not valid."]); end
		if @event.happening_case.invalid? ; raise Errors::ValidationError.new(:new, @event.happening_case.errors); end
		if @event.invalid? ; raise Errors::ValidationError.new(:new, @event.errors); end

		if !@event.save ; raise Errors::FlowError.new(new_event_path, @event.errors); end

		# secondary database actions
		unless @event.create_offering_creation(creator_id: @current_user_id)
			@event.destroy
			raise Errors::LoudMalfunction.new("E0701")
		end
		unless @event.offering_administrations.create(administrator_id: @current_user_id)
			@event.destroy
			raise Errors::LoudMalfunction.new("E0702")
		end	
		unless @event.create_activity(:create, owner: current_user)
			silent_malfunction_error_handler("E0703")			
		end

		# done
		redirect_to @event, notice: "Event was created"
	end

	def destroy
		@user = current_user
		@event = Event.find(params[:id])

		unless user_is_admin?(@event) && user_created_this?(@event); raise Errors::FlowError.new(events_path, "Permission denied."); end

		if !@event.destroy; raise Errors::FlowError.new(@event); end
		@event.create_activity :destroy, owner: current_user

		redirect_to(events_path)
	end

	def show
		begin
			@event = Event.find(params[:id])
		rescue
			raise Errors::FlowError.new(events_path, "Event not found.")
		end
		add_breadcrumb "events", events_path, :title => "Back to the Index"
		add_breadcrumb @event.title, event_path(@event)
		@likes = @event.flaggings.with_flag(:like)
		@photo = Photo.new
		@album = @event.album
		if ["male", "female"].include? @event.gender
			@teams = Team.where("gender = ?", @event.gender)
		else
			@teams = Team.all
		end
		@my_teams = []
		current_user.teams_administrating.each do |team|
			unless team_is_participating?(@event, team)
				@my_teams << team
			end
		end
		@owner = @event

		if @event.location.parent_id.nil?
			@location = @event.location
		else
			@location = @event.location.parent_location
		end

		@json = @location.to_gmaps4rails
		@recent_activities =  PublicActivity::Activity.where(trackable_type: "Event", trackable_id: @event.id)
		@recent_activities = @recent_activities.order("created_at desc")

		if @event.team_participation == false
			@participator = @event.individual_participators
		else
			@participator = @event.team_participators
		end

	end

	def edit
		begin
			@event = Event.find(params[:id])
		rescue
			raise Errors::FlowError.new(events_path, "Event not found.")
		end
		@happening_case = @event.happening_case
		@event.album ||= Album.new
		@location = @event.location
		@venues = Venue.all
		@photo = Photo.new
		@photo.title = "Logo"

	end

	def update
		@event = Event.find(params[:id])
		@venues = Venue.all
		@photo = Photo.new
		@photo.title = "Logo"
		@location = @event.location
		@happening_case = @event.happening_case

		# # gender
		# if ["male", "female"].include? params[:event][:gender]
		#   unless current_user.gender == params[:event][:gender]; raise Errors::FlowError.new(root_path, "This event is #{@event.gender} only."); end
		# end
		
		# update location
		if changing_location_parent?(@event) || changing_location_to_parent?(@event)
			params[:event].delete :location
			referenced_location = venue_location(params[:referenced_venue_id])
			if !referenced_location; raise Errors::ValidationError.new(:edit, "Address is not valid."); end
			copy_locations(referenced_location, @event.location)
			@event.location.parent_id = referenced_location.id # change location parent
		elsif changing_location_to_custom?(@event) || changing_custom_location?(@event, :event)
			set_params_gmaps_flag :event
			location = params[:event].delete :location
			temp_location = Location.new(location)
			if temp_location.invalid?; raise Errors::ValidationError.new(:edit, "Address is not valid.");end;
			copy_locations(temp_location, @event.location)

			@event.location.parent_id = nil # change to custom
			@location = @event.location				
		else
			params[:event].delete :location
		end

		if @event.location.invalid?; raise Errors::ValidationError.new(:edit, @event.location.errors); end

		# update and validate happening_case
		@event.happening_case.assign_attributes params[:happening_case]
		if @event.happening_case.invalid?; raise Errors::ValidationError.new(:edit, @event.happening_case.errors); end

		@happening_case = @event.happening_case
		# update and validate happening_case


		@event.assign_attributes safe_param

		if @event.invalid?; raise Errors::ValidationError.new(:edit, @event.errors); end
		if !@event.save; raise Errors::FlowError.new(:edit, @event.errors); end		

		# secondary database actions
		unless @event.create_activity :update, owner: current_user
			silent_malfunction_error_handler("E0704")	
		end

		# done
		redirect_to @event, notice: "Game was updated"

	end

	private

		def user_must_be_admin?
			@event = Event.find(params[:id])
			@user = current_user
			redirect_to(@event) and return unless @event.administrators.include?(@user)
		end

		def can_create
		  redirect_to root_path and return unless current_user.can_create? "event"
		end

		def safe_param
			this = Hash.new
			this[:title] = params[:event][:title] unless params[:event][:title].nil?
			this[:description] = params[:event][:description] unless params[:event][:description].nil?
			this[:category] = params[:event][:category] unless params[:event][:category].nil?
			this[:fee] = params[:event][:fee] unless params[:event][:fee].nil?
			this[:fee_type] = params[:event][:fee_type] unless params[:event][:fee_type].nil?
			this[:sport] = params[:event][:sport] unless params[:event][:sport].nil?
			this[:number_of_attendings] = params[:event][:number_of_attendings] unless params[:event][:number_of_attendings].nil?
			this[:team_participation] = params[:event][:team_participation] unless params[:event][:team_participation].nil?
			this[:open_join] = params[:event][:open_join] unless params[:event][:open_join].nil?
			this[:gender] = params[:event][:gender] unless params[:event][:gender].nil?
			this
		end	

end
