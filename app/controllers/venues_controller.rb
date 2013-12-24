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

			# with(:price, params[:min_price].to_i..params[:max_price].to_i) if params[:max_price].present? && params[:min_price].present?
			# with(:price).greater_than(params[:min_price].to_i) if !params[:max_price].present? && params[:min_price].present?
			# with(:price).less_than(params[:max_price].to_i) if params[:max_price].present? && !params[:min_price].present?

			# with(:condition, params[:condition]) if params[:condition].present?

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
		@venue = Venue.new(title: params[:venue][:title], descreption: params[:venue][:descreption], gender: params[:venue][:gender])
		@venue.album = Album.new

		# # gender
		# if ["male", "female"].include? @venue.gender
		# 	unless current_user.gender == @venue.gender; raise Errors::FlowError.new(root_path, "This venue is #{@venue.gender} only."); end
		# end

		# here, location assignment operation should take place.
						set_params_gmaps_flag :venue
		@venue.build_location(params[:venue][:location])

		if !@venue.save; raise Errors::FlowError.new(new_venue_path, "There has been a problem with data entry."); end

		@venue.create_activity :create, owner: current_user
		@venue.create_offering_creation(creator_id: @current_user_id)
		@venue.offering_administrations.create(administrator_id: @current_user_id)
		redirect_to @venue, notice: "Venue was created"

	end

  def destroy
		@user = current_user
		@venue = Venue.find(params[:id])

		unless user_is_admin?(@venue) && user_created_this?(@venue); raise Errors::FlowError.new(venues_path); end

		@venue.create_activity :destroy, owner: current_user
		if !@venue.destroy; raise Errors::FlowError.new(@venue); end

		redirect_to @venue
	end

	def show
		@venue = Venue.find(params[:id])
			add_breadcrumb "venues", venues_path, :title => "Back to the Index"
			add_breadcrumb @venue.title, venue_path(@venue)
		@offering_session =  OfferingSession.new

		if params[:session_id]
			@offering_session_edit = OfferingSession.find(params[:session_id])
			@edit_happening_case = @offering_session_edit.happening_case
		else
			@offering_session_edit = OfferingSession.new
			@edit_happening_case = HappeningCase.new
		end

		@happening_case = HappeningCase.new

		@date = params[:date] ? Date.parse(params[:date]) : Date.today

		@json = @venue.location.to_gmaps4rails

		@likes = @venue.flaggings.with_flag(:like)
		@photo = Photo.new
		@album = @venue.album
		@owner = @venue
		@location = @venue.location
		@recent_activities =  PublicActivity::Activity.where(trackable_type: "Venue", trackable_id: @venue.id)
		@recent_activities = @recent_activities.order("created_at desc")

		@grouped_happening_cases = grouped_happening_cases(@venue)
		@grouped_sessions = replace_with_happening(@grouped_happening_cases)

		@date = params[:date] ? Date.parse(params[:date]) : Date.today

		@collectives = @venue.collectives

	end

	def edit
		@venue = Venue.find(params[:id])
		@venue.album ||= Album.new
		@location = @venue.location
		@photo = Photo.new
		@photo.title = "Logo"
	end

	def update
		@venue = Venue.find(params[:id])
		@location = @venue.location
						set_params_gmaps_flag :venue

		# # gender
		# if ["male", "female"].include? params[:venue][:gender]
		# 	unless current_user.gender == params[:venue][:gender]; raise Errors::FlowError.new(root_path, "This venue is #{@venue.gender} only."); end
		# end

		unless @venue.update_attributes(title: params[:venue][:title], descreption: params[:venue][:descreption], gender: params[:venue][:gender]) && @location.update_attributes(city: params[:venue][:location][:city], custom_address_use: params[:venue][:location][:custom_address_use], longitude: params[:venue][:location][:longitude], latitude: params[:venue][:location][:latitude], gmap_use: params[:venue][:location][:gmap_use], custom_address: params[:venue][:location][:custom_address], gmaps: params[:venue][:location][:gmaps])
			raise Errors::FlowError.new(edit_venue_path(@venue), "There has been a problem with data entry.")
		end

		@venue.create_activity :update, owner: current_user
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


end
