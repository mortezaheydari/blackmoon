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
		@current_user_id = current_user.id
		set_params_gmaps_flag :event
		location = params[:event].delete :location
		@event = Event.new(params[:event])
		@event.album = Album.new
		@event.happening_case = HappeningCase.new(params[:happening_case])

	    # gender restriction
	    if ["male", "female"].include? @event.gender
	      unless current_user.gender == @event.gender; raise Errors::FlowError.new(root_path, "This action is not possible because of gender restriction."); end
	    end
		@event.build_location(location)

		# custom or referenced location.
		if params[:location_type] == "parent_location"
			referenced_location = venue_location(params[:referenced_venue_id])
			if !referenced_location; raise Errors::FlowError.new(new_event_path, "location not valid"); end
			copy_locations(referenced_location, @event.location)
			@event.location.parent_id = referenced_location.id
		else
			@event.location.parent_id = nil
		end

		# here, location assignment operation should take place.
		if !@event.save ; raise Errors::FlowError.new(new_event_path, "there has been a problem with data entry."); end

		@event.create_offering_creation(creator_id: @current_user_id)
		@event.offering_administrations.create(administrator_id: @current_user_id)
		@event.create_activity :create, owner: current_user

		redirect_to @event, notice: "Event was created"
	end

	def destroy
		@user = current_user
		@event = Event.find(params[:id])

		unless user_is_admin?(@event) && user_created_this?(@event); raise Errors::FlowError.new(events_path); end

		if !@event.destroy; raise Errors::FlowError.new(@event); end
		@event.create_activity :destroy, owner: current_user

		redirect_to(events_path)
	end

	def show
		@event = Event.find(params[:id])
		add_breadcrumb "events", events_path, :title => "Back to the Index"
		add_breadcrumb @event.title, event_path(@event)
		@likes = @event.flaggings.with_flag(:like)
        @teams = Team.all
        @my_teams = []
        current_user.teams_administrating.each do |team|
            unless team_is_participating?(@event, team)
                @my_teams << team
            end
        end
		@photo = Photo.new
		@album = @event.album
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
		@event = Event.find(params[:id])
		@happening_case = @event.happening_case
		@event.album ||= Album.new
		@location = @event.location
		@venues = Venue.all
		@photo = Photo.new
		@photo.title = "Logo"

	end

	def update
		@event = Event.find(params[:id])

	    # gender restriction
	    if ["male", "female"].include? params[:event][:gender]
	      unless current_user.gender == params[:event][:gender]; raise Errors::FlowError.new(root_path, "This action is not possible because of gender restriction."); end
	    end
		# update location
		if changing_location_parent?(@event) || changing_location_to_parent?(@event)
			params[:event].delete :location
			referenced_location = venue_location(params[:referenced_venue_id])
			if !referenced_location; raise Errors::FlowError.new(new_event_path, "location not valid"); end
			copy_locations(referenced_location, @event.location)
			@event.location.parent_id = referenced_location.id
			# change location parent
		elsif changing_location_to_custom?(@event) || changing_custom_location?(@event, :event)
			set_params_gmaps_flag :event
			location = params[:event].delete :location
			temp_location = Location.new(location)
			if temp_location.invalid?; raise Errors::FlowError.new(edit_event_path, "location not valid");end;
			copy_locations(temp_location, @event.location)
			if @event.location.invalid?
				errors = "Location invalid. "
				@event.location.errors.each { |m| errors +=  (m.first.to_s + ": " + m.last.first.to_s + "; ") }
				raise Errors::FlowError.new(edit_event_path(@event), errors)
			end
			@event.location.parent_id = nil
			# change to custom
		else
			params[:event].delete :location
			# do nothing
		end

		if !@event.happening_case.update_attributes params[:happening_case]; raise Errors::FlowError.new(edit_event_path(@event)); end
		if !@event.update_attributes(params[:event]); raise Errors::FlowError.new(edit_event_path(@event)); end
		if !@event.create_activity :update, owner: current_user; raise Errors::FlowError.new(edit_event_path(@event)); end

		redirect_to @event, notice: "Event was updated"
	end

	private

	 def user_must_be_admin?
		 @event = Event.find(params[:id])
		 @user = current_user
		 redirect_to(@event) and return unless @event.administrators.include?(@user)
	 end

end
