class VenuesController < ApplicationController

	include SessionsHelper
	include MultiSessionsHelper
	before_filter :can_create, only: [:create]
	before_filter :authenticate_account!, only: [:new, :create, :edit, :destroy, :like]
	before_filter :user_must_be_admin?, only: [:edit, :destroy]
			add_breadcrumb "home", :root_path

	def like

		@venue = Venue.find(params[:id])

		if current_user.flagged?(@venue, :like)
			current_user.unflag(@venue, :like)
			msg = "you now don't like this venue."
		else
			current_user.flag(@venue, :like)
			msg = "you now like this venue."
		end

		respond_to do |format|
			format.html { redirect_to @venue}
			format.js
		end
	end

	def like_cards

		@venue = Venue.find(params[:id])

		# current_user.unflag(@venue, :like)
		current_user.toggle_flag(@venue, :like)

		respond_to do |format|
			format.js { render 'shared/offering/like_cards', :locals => { offering: @venue, style_id: params[:style_id], class_name: params[:class_name] } }
		end
	end

	def index
		add_breadcrumb "venues", venues_path, :title => "Back to the Index"

		@search = Sunspot.search(Venue) do
			fulltext params[:search]

			facet(:city)
			with(:city, params[:city]) if params[:city].present?

			facet(:gender)
			with(:gender, params[:gender]) if params[:gender].present?

			order_by(:updated_at, :desc)

		end
		@venues = @search.results

		@recent_activities = PublicActivity::Activity.where(trackable_type: "Venue")
		@recent_activities = @recent_activities.order("created_at desc")
	end

	def new
		@venue = Venue.new
		@location = Location.new
	end

	def create
		@current_user_id = current_user.id
		@venue = Venue.new(safe_param)
		@venue.album = Album.new
		
		set_params_gmaps_flag :venue

		# # gender
		# if ["male", "female"].include? @venue.gender
		# 	unless current_user.gender == @venue.gender; raise Errors::FlowError.new(root_path, "This venue is #{@venue.gender} only."); end
		# end

		# location assignment and validation
		@location = @venue.build_location(safe_location_param)
		if @location.invalid? ; raise Errors::ValidationError.new(:new, ["Address is not valid."]); end

		# venue validation and save
		if @venue.invalid?; raise Errors::ValidationError.new(:new, @venue.errors); end
		if !@venue.save; raise Errors::FlowError.new(new_venue_path, @venue.errors); end

		# secondary database actions
		unless @venue.create_offering_creation(creator_id: @current_user_id)
			@venue.destroy
			raise Errors::LoudMalfunction.new("E0201")
		end
		unless @venue.offering_administrations.create(administrator_id: @current_user_id)
			@venue.destroy
			raise Errors::LoudMalfunction.new("E0202")
		end	
		unless @venue.create_activity(:create, owner: current_user)
			silent_malfunction_error_handler("E0203")		
		end

		# done
		redirect_to @venue, notice: "Venue was created"

	end

  def destroy
		@user = current_user
		@venue = Venue.find(params[:id])

		unless user_is_admin?(@venue) && user_created_this?(@venue); raise Errors::FlowError.new(venues_path, "Permission denied."); end

		if !@venue.destroy; raise Errors::FlowError.new(@venue); end

		@venue.create_activity :destroy, owner: current_user

		redirect_to @venue
	end

	def show
		begin
			@venue = Venue.find(params[:id])
		rescue
			raise Errors::FlowError.new(venues_path, "Venue not found.")
		end
		add_breadcrumb "venues", venues_path, :title => "Back to the Index"
		add_breadcrumb @venue.title, venue_path(@venue)
		@likes = @venue.flaggings.with_flag(:like)
		@photo = Photo.new
		@album = @venue.album
		@owner = @venue		
		@happening_case = HappeningCase.new
		@offering_session = OfferingSession.new

		@location = @venue.location

		if params[:session_id]
			@offering_session_edit = OfferingSession.find(params[:session_id])
			@edit_happening_case = @offering_session_edit.happening_case
		else
			@offering_session_edit = OfferingSession.new
			@edit_happening_case = HappeningCase.new
		end

		@date = params[:date] ? Date.parse(params[:date]) : Date.today
		@json = @venue.location.to_gmaps4rails

		@recent_activities =  PublicActivity::Activity.where(trackable_type: "Venue", trackable_id: @venue.id)
		@recent_activities = @recent_activities.order("created_at desc")

		@grouped_happening_cases = grouped_happening_cases(@venue)
		@grouped_sessions = replace_with_happening(@grouped_happening_cases)

		@collectives = @venue.collectives

	end

	def edit
		begin
			@venue = Venue.find(params[:id])
		rescue
			raise Errors::FlowError.new(venues_path, "Venue not found.")
		end				
		@venue.album ||= Album.new
		@location = @venue.location
		@photo = Photo.new
		@photo.title = "Logo"
	end

	def update
		@venue = Venue.find(params[:id])
		@location = @venue.location
		@photo = Photo.new
		@photo.title = "Logo"		
		set_params_gmaps_flag :venue

		# # gender
		# if ["male", "female"].include? params[:venue][:gender]
		# 	unless current_user.gender == params[:venue][:gender]; raise Errors::FlowError.new(root_path, "This venue is #{@venue.gender} only."); end
		# end

		# update and validate location
		@location = @venue.location.assign_attributes(safe_location_param)
		if @venue.location.invalid?; raise Errors::ValidationError.new(:edit, ["Address is not valid."]); end
		
		# update and validate venue
		@venue.assign_attributes safe_param

		if @venue.invalid?; raise Errors::ValidationError.new(:edit, @venue.errors); end
		if !@venue.save; raise Errors::FlowError.new(:edit, @venue.errors); end

		# secondary database actions
		unless @venue.create_activity :update, owner: current_user
			silent_malfunction_error_handler("E0204")
		end

		# done
		redirect_to @venue, notice: "Venue was updated"
	end

	private

		def user_must_be_admin?
			@venue = Venue.find(params[:id])
			@user = current_user
			redirect_to(@venue) and return unless @venue.administrators.include?(@user)
		end

		def can_create
			redirect_to root_path and return unless current_user.can_create? "venue"
		end

		def safe_param
			this = Hash.new
			this[:title] = params[:venue][:title] unless params[:venue][:title].nil?
			this[:descreption] = params[:venue][:descreption] unless params[:venue][:descreption].nil?
			this[:gender] = params[:venue][:gender] unless params[:venue][:gender].nil?
			this
		end

		def safe_location_param
			this = Hash.new
			this[:city] = params[:venue][:location][:city] unless params[:venue][:location][:city].nil?
			this[:custom_address_use] = params[:venue][:location][:custom_address_use] unless params[:venue][:location][:custom_address_use].nil?
			this[:longitude] = params[:venue][:location][:longitude] unless params[:venue][:location][:longitude].nil?
			this[:latitude] = params[:venue][:location][:latitude] unless params[:venue][:location][:latitude].nil?
			this[:gmap_use] = params[:venue][:location][:gmap_use] unless params[:venue][:location][:gmap_use].nil?
			this[:custom_address] = params[:venue][:location][:custom_address] unless params[:venue][:location][:custom_address].nil?
			this[:gmaps] = params[:venue][:location][:gmaps] unless params[:venue][:location][:gmaps].nil?
			this
		end		

end
