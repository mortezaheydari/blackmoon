class VenuesController < ApplicationController

	include SessionsHelper
            include VenueHelper
	before_filter :authenticate_account!, only: [:new, :create, :edit, :destroy, :like]
	before_filter :user_must_be_admin?, only: [:edit, :destroy]

#	@model_name = "Venue"
#
#	include Liking
#		# like
#		# like_card

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
		@venues = Venue.all
		@recent_activities = PublicActivity::Activity.where(trackable_type: "Venue")
		@recent_activities = @recent_activities.order("created_at desc")
	end

	def new
		@venue = Venue.new
		@location = Location.new
	end

	def create
		@current_user_id = current_user.id
		@venue = Venue.new(title: params[:venue][:title], descreption: params[:venue][:descreption])
		@venue.album = Album.new

		# here, location assignment operation should take place.
		if params[:venue][:location][:longitude].empty? || params[:venue][:location][:latitude].empty?
			params[:venue][:location][:gmaps] = false
		else
			params[:venue][:location][:gmaps] = true
		end
		@venue.build_location(params[:venue][:location])

			double_check(new_venue_path, "There has been a problem with data entry.") {
		@venue.save }

		@venue.create_activity :create, owner: current_user
		@venue.create_offering_creation(creator_id: @current_user_id)
		@venue.offering_administrations.create(administrator_id: @current_user_id)
		redirect_to @venue, notice: "Venue was created"

	end

	def destroy
		@user = current_user
		@venue = Venue.find(params[:id])
			double_check(venues_path) {
		user_is_admin?(@venue) && user_created_this?(@venue) }

		@venue.create_activity :destroy, owner: current_user
		@venue.destroy

		redirect_to @venue
	end

	def show
		@venue = Venue.find(params[:id])
        @offering_session =  OfferingSession.new

        if params[:session_id]
            @offering_session_edit = OfferingSession.find(params[:session_id])
            @edit_happening_case = @offering_session_edit.happening_case
        else
            @offering_session_edit = OfferingSession.find(1)
            @edit_happening_case = @offering_session_edit.happening_case
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

        @collectives = Collective.all

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
		if params[:venue][:location][:longitude].empty? || params[:venue][:location][:latitude].empty?
			params[:venue][:location][:gmaps] = false
		else
			params[:venue][:location][:gmaps] = true
		end

			double_check(edit_venue_path(@venue), "There has been a problem with data entry.") {
		@venue.update_attributes(title: params[:venue][:title], descreption: params[:venue][:descreption]) && @location.update_attributes(city: params[:venue][:location][:city], custom_address_use: params[:venue][:location][:custom_address_use], longitude: params[:venue][:location][:longitude], latitude: params[:venue][:location][:latitude], gmap_use: params[:venue][:location][:gmap_use], custom_address: params[:venue][:location][:custom_address], gmaps: params[:venue][:location][:gmaps]) }

		@venue.create_activity :update, owner: current_user
		redirect_to @venue, notice: "Venue was updated"
	end

	private

		def user_must_be_admin?
			@venue = Venue.find(params[:id])
			@user = current_user
			redirect_to(@venue) unless @venue.administrators.include?(@user)
		end

		def sorted_offering_sessions(venue)
			session_id_list = []
			venue.offering_sessions.each do |os|
				session_id_list << os.id
			end

			sorted_happening_cases = HappeningCase.where(happening_type: "OfferingSession", happening_id: session_id_list).order(:date_and_time)

			sorted_sessions = []
			sorted_happening_cases.each do |hc|
				sorted_sessions << hc.id
			end
			sorted_sessions
		end

                        def grouped_happening_cases(this)
                            session_id_list = []
                            this.offering_sessions.each do |os|
                                session_id_list << os.id
                            end

                            sorted_happening_cases = HappeningCase.where(happening_type: "OfferingSession", happening_id: session_id_list).group_by(&:date_and_time)
                        end


                        def replace_with_happening(grouped_happening_cases)
                            grouped_sessions = Hash.new
                            grouped_happening_cases.each do |key, value|
                                grouped_sessions[key.to_date] = []
                                value.each do |happening_case|
                                    grouped_sessions[key.to_date] << happening_case.happening
                                end
                            end
                            grouped_sessions
                        end
end
