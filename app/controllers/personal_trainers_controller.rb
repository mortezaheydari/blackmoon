class PersonalTrainersController < ApplicationController

	include SessionsHelper
			include MultiSessionsHelper
	before_filter :can_create, only: [:create]
	before_filter :authenticate_account!, only: [:new, :create, :edit, :destroy, :like]
	before_filter :user_must_be_admin?, only: [:edit, :destroy]
			add_breadcrumb "home", :root_path

	def like

		@personal_trainer = PersonalTrainer.find(params[:id])

		if current_user.flagged?(@personal_trainer, :like)
			current_user.unflag(@personal_trainer, :like)
			msg = "you now don't like this personal trainer."
		else
			current_user.flag(@personal_trainer, :like)
			msg = "you now like this personal trainer."
		end

		respond_to do |format|
			format.html { redirect_to @personal_trainer}
			format.js
		end
	end

	def like_cards

		@personal_trainer = PersonalTrainer.find(params[:id])

		# current_user.unflag(@personal_trainer, :like)
		current_user.toggle_flag(@personal_trainer, :like)

		respond_to do |format|
				format.js { render 'shared/offering/like_cards', :locals => { offering: @personal_trainer, style_id: params[:style_id], class_name: params[:class_name] } }
		end
	end

	def index
		add_breadcrumb "personal trainers", personal_trainers_path, :title => "Back to the Index"

		@search = Sunspot.search(PersonalTrainer) do
			fulltext params[:search]

			facet(:city)
			with(:city, params[:city]) if params[:city].present?

			facet(:gender)
			with(:gender, params[:gender]) if params[:gender].present?

			order_by(:updated_at, :desc)

		end
		@personal_trainers = @search.results

		@recent_activities = PublicActivity::Activity.where(trackable_type: "PersonalTrainer")
		@recent_activities = @recent_activities.order("created_at desc")
	end

	def new
		@personal_trainer = PersonalTrainer.new
		@location = Location.new
	end

	def create
		@current_user_id = current_user.id
		@personal_trainer = PersonalTrainer.new(safe_param)
		@personal_trainer.album = Album.new

		set_params_gmaps_flag :personal_trainer

		# # gender
		# if ["male", "female"].include? @personal_trainer.gender
		# 	unless current_user.gender == @personal_trainer.gender; raise Errors::FlowError.new(root_path, "This personal trainer is #{@personal_trainer.gender} only."); end
		# end

		# location assignment and validation
		@location = @personal_trainer.build_location(safe_location_param)
		if @location.invalid? ; raise Errors::ValidationError.new(:new, ["Address is not valid."]); end

		# personal_trainer validation and save
		if @personal_trainer.invalid?; raise Errors::ValidationError.new(:new, @personal_trainer.errors); end
		if !@personal_trainer.save; raise Errors::FlowError.new(new_personal_trainer_path, @personal_trainer.errors); end

		# secondary database actions
		unless @personal_trainer.create_offering_creation(creator_id: @current_user_id)
			@personal_trainer.destroy
			raise Errors::LoudMalfunction.new("E0301")
		end
		unless @personal_trainer.offering_administrations.create(administrator_id: @current_user_id)
			@personal_trainer.destroy
			raise Errors::LoudMalfunction.new("E0302")
		end
		unless @personal_trainer.create_activity(:create, owner: current_user)
			silent_malfunction_error_handler("E0303")
		end

		# done
		redirect_to @personal_trainer, notice: "Personal trainer page was created"

	end

	def destroy
		@user = current_user
		@personal_trainer = PersonalTrainer.find(params[:id])

		unless user_is_admin?(@personal_trainer) && user_created_this?(@personal_trainer); raise Errors::FlowError.new(personal_trainers_path, "Permission denied."); end

		if !@personal_trainer.destroy; raise Errors::FlowError.new(@personal_trainer); end
		@personal_trainer.create_activity :destroy, owner: current_user

		redirect_to @personal_trainer
	end

	def show
		begin
			@personal_trainer = PersonalTrainer.find(params[:id])
		rescue
			raise Errors::FlowError.new(personal_trainers_path, "Personal trainer not found.")
		end
		add_breadcrumb "Personal Trainers", personal_trainers_path, :title => "Back to the Index"
		add_breadcrumb @personal_trainer.title, personal_trainer_path(@personal_trainer)
		@likes = @personal_trainer.flaggings.with_flag(:like)
		@photo = Photo.new
		@album = @personal_trainer.album
		@owner = @personal_trainer
		@happening_case = HappeningCase.new
		@offering_session =  OfferingSession.new

		@location = @personal_trainer.location

		if params[:session_id]
			@offering_session_edit = OfferingSession.find(params[:session_id])
			@edit_happening_case = @offering_session_edit.happening_case
		else
			@offering_session_edit = OfferingSession.new
			@edit_happening_case = HappeningCase.new
		end

		@date = params[:date] ? Date.parse(params[:date]) : Date.today
		@json = @personal_trainer.location.to_gmaps4rails

		@recent_activities =  PublicActivity::Activity.where(trackable_type: "PersonalTrainer", trackable_id: @personal_trainer.id)
		@recent_activities = @recent_activities.order("created_at desc")

		@grouped_happening_cases = grouped_happening_cases(@personal_trainer)
		@grouped_sessions = replace_with_happening(@grouped_happening_cases)

		@collectives = @personal_trainer.collectives

	end

	def edit
		begin
			@personal_trainer = PersonalTrainer.find(params[:id])
		rescue
			raise Errors::FlowError.new(personal_trainers_path, "Personal trainer not found.")
		end
		@personal_trainer.album ||= Album.new
		@location = @personal_trainer.location
		@photo = Photo.new
		@photo.title = "Logo"
	end

	def update
		@personal_trainer = PersonalTrainer.find(params[:id])
		@location = @personal_trainer.location
		@photo = Photo.new
		@photo.title = "Logo"
		set_params_gmaps_flag :personal_trainer

		# # gender
		# if ["male", "female"].include? params[:personal_trainer][:gender]
		# 	unless current_user.gender == params[:personal_trainer][:gender]; raise Errors::FlowError.new(root_path, "This personal trainer is #{@personal_trainer.gender} only."); end
		# end

		# update and validate location
		@location = @personal_trainer.location.assign_attributes(safe_location_param)
		if @personal_trainer.location.invalid?; raise Errors::ValidationError.new(:edit, ["Address is not valid."]); end

		# update and validate venue
		@personal_trainer.assign_attributes safe_param

		if @personal_trainer.invalid?; raise Errors::ValidationError.new(:edit, @personal_trainer.errors); end
		if !@personal_trainer.save; raise Errors::FlowError.new(:edit, @personal_trainer.errors); end

		# secondary database actions
		unless @personal_trainer.create_activity :update, owner: current_user
			silent_malfunction_error_handler("E0304")
		end

		# done
		redirect_to @personal_trainer, notice: "Personal Trainer page was updated"
	end

	private

		def user_must_be_admin?
			@personal_trainer = PersonalTrainer.find(params[:id])
			@user = current_user
			redirect_to(@personal_trainer) and return unless @personal_trainer.administrators.include?(@user)
		end
		def can_create
			redirect_to root_path and return unless current_user.can_create? "personal_trainer"
		end

		def safe_param
			this = Hash.new
			this[:title] = params[:personal_trainer][:title] unless params[:personal_trainer][:title].nil?
			this[:descreption] = params[:personal_trainer][:descreption] unless params[:personal_trainer][:descreption].nil?
			this[:gender] = params[:personal_trainer][:gender] unless params[:personal_trainer][:gender].nil?
			this
		end

		def safe_location_param
			this = Hash.new
			this[:city] = params[:personal_trainer][:location][:city] unless params[:personal_trainer][:location][:city].nil?
			this[:custom_address_use] = params[:personal_trainer][:location][:custom_address_use] unless params[:personal_trainer][:location][:custom_address_use].nil?
			this[:longitude] = params[:personal_trainer][:location][:longitude] unless params[:personal_trainer][:location][:longitude].nil?
			this[:latitude] = params[:personal_trainer][:location][:latitude] unless params[:personal_trainer][:location][:latitude].nil?
			this[:gmap_use] = params[:personal_trainer][:location][:gmap_use] unless params[:personal_trainer][:location][:gmap_use].nil?
			this[:custom_address] = params[:personal_trainer][:location][:custom_address] unless params[:personal_trainer][:location][:custom_address].nil?
			this[:gmaps] = params[:personal_trainer][:location][:gmaps] unless params[:personal_trainer][:location][:gmaps].nil?
			this
		end
end
