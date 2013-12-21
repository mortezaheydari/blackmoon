class GroupTrainingsController < ApplicationController
	include SessionsHelper
			include MultiSessionsHelper
	before_filter :can_create, only: [:create]			
	before_filter :authenticate_account!, only: [:new, :create, :edit, :destroy, :like]
	before_filter :user_must_be_admin?, only: [:edit, :destroy]
			add_breadcrumb "home", :root_path

	def like

		@group_training = GroupTraining.find(params[:id])

		if current_user.flagged?(@group_training, :like)
			current_user.unflag(@group_training, :like)
			msg = "you now don't like this group training."
		else
			current_user.flag(@group_training, :like)
			msg = "you now like this group training."
		end

		respond_to do |format|
			format.html { redirect_to @group_training}
			format.js
		end
	end

	def like_cards

		@group_training = GroupTraining.find(params[:id])

		# current_user.unflag(@group_training, :like)
		current_user.toggle_flag(@group_training, :like)

		respond_to do |format|
				format.js { render 'shared/offering/like_cards', :locals => { offering: @group_training, style_id: params[:style_id], class_name: params[:class_name] } }
		end
	end

	def index
		add_breadcrumb "group_trainings", group_trainings_path, :title => "Back to the Index"

		@search = Sunspot.search(GroupTraining) do
			fulltext params[:search]

			# with(:price, params[:min_price].to_i..params[:max_price].to_i) if params[:max_price].present? && params[:min_price].present?
			# with(:price).greater_than(params[:min_price].to_i) if !params[:max_price].present? && params[:min_price].present?
			# with(:price).less_than(params[:max_price].to_i) if params[:max_price].present? && !params[:min_price].present?

			# with(:condition, params[:condition]) if params[:condition].present?

			facet(:city)
			with(:city, params[:city]) if params[:city].present?

			order_by(:updated_at, :desc)
			# if params[:order_by] == "Price"
			#   order_by(:price)
			# elsif params[:order_by] == "Popular"
			#   order_by(:favorite_count, :desc)
			# end

		end
		@group_trainings = @search.results

		@recent_activities = PublicActivity::Activity.where(trackable_type: "GroupTraining")
		@recent_activities = @recent_activities.order("created_at desc")
	end

	def new
		@group_training = GroupTraining.new
		@location = Location.new
	end

	def create
		@current_user_id = current_user.id
		@group_training = GroupTraining.new(title: params[:group_training][:title], descreption: params[:group_training][:descreption])
		@group_training.album = Album.new

		# here, location assignment operation should take place.
						set_params_gmaps_flag :group_training
		@group_training.build_location(params[:group_training][:location])

		if !@group_training.save; raise Errors::FlowError.new(new_group_training_path, "There has been a problem with data entry."); end

		@group_training.create_activity :create, owner: current_user
		@group_training.create_offering_creation(creator_id: @current_user_id)
		@group_training.offering_administrations.create(administrator_id: @current_user_id)
		redirect_to @group_training, notice: "Group Training page was created"

	end

	def destroy
		@user = current_user
		@group_training = GroupTraining.find(params[:id])

		unless user_is_admin?(@group_training) && user_created_this?(@group_training); raise Errors::FlowError.new(group_trainings_path); end

		if !@group_training.destroy; raise Errors::FlowError.new(@group_training); end
		@group_training.create_activity :destroy, owner: current_user

		redirect_to @group_training
	end

	def show
		@group_training = GroupTraining.find(params[:id])
				add_breadcrumb "Classes", group_trainings_path, :title => "Back to the Index"
				add_breadcrumb @group_training.title, group_training_path(@group_training)
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

		@json = @group_training.location.to_gmaps4rails

		@likes = @group_training.flaggings.with_flag(:like)
		@photo = Photo.new
		@album = @group_training.album
		@owner = @group_training
		@location = @group_training.location
		@recent_activities =  PublicActivity::Activity.where(trackable_type: "GroupTraining", trackable_id: @group_training.id)
		@recent_activities = @recent_activities.order("created_at desc")

		@grouped_happening_cases = grouped_happening_cases(@group_training)
		@grouped_sessions = replace_with_happening(@grouped_happening_cases)

		@date = params[:date] ? Date.parse(params[:date]) : Date.today

		@collectives = @group_training.collectives

	end

	def edit
		@group_training = GroupTraining.find(params[:id])
		@group_training.album ||= Album.new
		@location = @group_training.location
		@photo = Photo.new
		@photo.title = "Logo"
	end

	def update
		@group_training = GroupTraining.find(params[:id])
		@location = @group_training.location
						set_params_gmaps_flag :group_training

		unless @group_training.update_attributes(title: params[:group_training][:title], descreption: params[:group_training][:descreption]) && @location.update_attributes(city: params[:group_training][:location][:city], custom_address_use: params[:group_training][:location][:custom_address_use], longitude: params[:group_training][:location][:longitude], latitude: params[:group_training][:location][:latitude], gmap_use: params[:group_training][:location][:gmap_use], custom_address: params[:group_training][:location][:custom_address], gmaps: params[:group_training][:location][:gmaps])
			raise Errors::FlowError.new(edit_group_training_path(@group_training), "There has been a problem with data entry.")
		end

		@group_training.create_activity :update, owner: current_user
		redirect_to @group_training, notice: "Group Training page was updated"
	end

	private

		def user_must_be_admin?
			@group_training = GroupTraining.find(params[:id])
			@user = current_user
			redirect_to(@group_training) and return unless @group_training.administrators.include?(@user)
		end
		def can_create
			redirect_to root_path and return unless current_user.can_create? "group_training"
		end
end