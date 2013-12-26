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
		add_breadcrumb "classes", group_trainings_path, :title => "Back to the Index"

		@search = Sunspot.search(GroupTraining) do
			fulltext params[:search]

			facet(:city)
			with(:city, params[:city]) if params[:city].present?

			facet(:gender)
			with(:gender, params[:gender]) if params[:gender].present?

			order_by(:updated_at, :desc)

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
		@group_training = GroupTraining.new(safe_param)
		@group_training.album = Album.new

		set_params_gmaps_flag :group_training

		# # gender
		# if ["male", "female"].include? @group_training.gender
		# 	unless current_user.gender == @group_training.gender; raise Errors::FlowError.new(root_path, "This class is #{@group_training.gender} only."); end
		# end

		# location assignment and validation
		@location = @group_training.build_location(safe_location_param)
		if @location.invalid? ; raise Errors::ValidationError.new(:new, ["Address is not valid."]); end

		# group_training validation and save
		if @group_training.invalid?; raise Errors::ValidationError.new(:new, @group_training.errors); end
		if !@group_training.save; raise Errors::FlowError.new(new_group_training_path, @group_training.errors); end

		# secondary database actions
		unless @group_training.create_offering_creation(creator_id: @current_user_id)
			@group_training.destroy
			raise Errors::LoudMalfunction.new("E0401")
		end
		unless @group_training.offering_administrations.create(administrator_id: @current_user_id)
			@group_training.destroy
			raise Errors::LoudMalfunction.new("E0402")
		end
		unless @group_training.create_activity(:create, owner: current_user)
			silent_malfunction_error_handler("E0403")
		end

		# done
		redirect_to @group_training, notice: "class page was created"

	end

	def destroy
		@user = current_user
		@group_training = GroupTraining.find(params[:id])

		unless user_is_admin?(@group_training) && user_created_this?(@group_training); raise Errors::FlowError.new(group_trainings_path, "Permission denied."); end

		if !@group_training.destroy; raise Errors::FlowError.new(@group_training); end
		@group_training.create_activity :destroy, owner: current_user

		redirect_to @group_training
	end

	def show
		begin
			@group_training = GroupTraining.find(params[:id])
		rescue
			raise Errors::FlowError.new(group_trainings_path, "Class not found.")
		end
		add_breadcrumb "Classes", group_trainings_path, :title => "Back to the Index"
		add_breadcrumb @group_training.title, group_training_path(@group_training)
		@likes = @group_training.flaggings.with_flag(:like)
		@photo = Photo.new
		@album = @group_training.album
		@owner = @group_training
		@happening_case = HappeningCase.new
		@offering_session =  OfferingSession.new

		@location = @group_training.location

		if params[:session_id]
			@offering_session_edit = OfferingSession.find(params[:session_id])
			@edit_happening_case = @offering_session_edit.happening_case
		else
			@offering_session_edit = OfferingSession.new
			@edit_happening_case = HappeningCase.new
		end


		@date = params[:date] ? Date.parse(params[:date]) : Date.today
		@json = @group_training.location.to_gmaps4rails

		@recent_activities =  PublicActivity::Activity.where(trackable_type: "GroupTraining", trackable_id: @group_training.id)
		@recent_activities = @recent_activities.order("created_at desc")

		@grouped_happening_cases = grouped_happening_cases(@group_training)
		@grouped_sessions = replace_with_happening(@grouped_happening_cases)

		@collectives = @group_training.collectives

	end

	def edit
		begin
			@group_training = GroupTraining.find(params[:id])
		rescue
			raise Errors::FlowError.new(group_trainings_path, "Class not found.")
		end
		@group_training.album ||= Album.new
		@location = @group_training.location
		@photo = Photo.new
		@photo.title = "Logo"
	end

	def update
		@group_training = GroupTraining.find(params[:id])
		@location = @group_training.location
		@photo = Photo.new
		@photo.title = "Logo"
		set_params_gmaps_flag :group_training

		# # gender
		# if ["male", "female"].include? params[:group_training][:gender]
		# 	unless current_user.gender == params[:group_training][:gender]; raise Errors::FlowError.new(root_path, "This class is #{@group_training.gender} only."); end
		# end

		# update and validate location
		@location = @group_training.location.assign_attributes(safe_location_param)
		if @group_training.location.invalid?; raise Errors::ValidationError.new(:edit, ["Address is not valid."]); end

		# update and validate venue
		@group_training.assign_attributes safe_param

		if @group_training.invalid?; raise Errors::ValidationError.new(:edit, @group_training.errors); end
		if !@group_training.save; raise Errors::FlowError.new(:edit, @group_training.errors); end

		# secondary database actions
		unless @group_training.create_activity :update, owner: current_user
			silent_malfunction_error_handler("E0404")
		end

		# done
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
		def safe_param
			this = Hash.new
			this[:title] = params[:group_training][:title] unless params[:group_training][:title].nil?
			this[:descreption] = params[:group_training][:descreption] unless params[:group_training][:descreption].nil?
			this[:gender] = params[:group_training][:gender] unless params[:group_training][:gender].nil?
			this
		end

		def safe_location_param
			this = Hash.new
			this[:city] = params[:group_training][:location][:city] unless params[:group_training][:location][:city].nil?
			this[:custom_address_use] = params[:group_training][:location][:custom_address_use] unless params[:group_training][:location][:custom_address_use].nil?
			this[:longitude] = params[:group_training][:location][:longitude] unless params[:group_training][:location][:longitude].nil?
			this[:latitude] = params[:group_training][:location][:latitude] unless params[:group_training][:location][:latitude].nil?
			this[:gmap_use] = params[:group_training][:location][:gmap_use] unless params[:group_training][:location][:gmap_use].nil?
			this[:custom_address] = params[:group_training][:location][:custom_address] unless params[:group_training][:location][:custom_address].nil?
			this[:gmaps] = params[:group_training][:location][:gmaps] unless params[:group_training][:location][:gmaps].nil?
			this
		end
end