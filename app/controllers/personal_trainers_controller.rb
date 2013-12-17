class PersonalTrainersController < ApplicationController

	include SessionsHelper
            include MultiSessionsHelper
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
                        add_breadcrumb "Personal Trainers", personal_trainers_path, :title => "Back to the Index"
		@personal_trainers = PersonalTrainer.all
		@recent_activities = PublicActivity::Activity.where(trackable_type: "PersonalTrainer")
		@recent_activities = @recent_activities.order("created_at desc")
	end

	def new
		@personal_trainer = PersonalTrainer.new
		@location = Location.new
	end

	def create
		@current_user_id = current_user.id
		@personal_trainer = PersonalTrainer.new(title: params[:personal_trainer][:title], descreption: params[:personal_trainer][:descreption])
		@personal_trainer.album = Album.new

		# here, location assignment operation should take place.
                        set_params_gmaps_flag :personal_trainer
		@personal_trainer.build_location(params[:personal_trainer][:location])

		if !@personal_trainer.save; raise Errors::FlowError.new(new_personal_trainer_path, "There has been a problem with data entry."); end

		@personal_trainer.create_activity :create, owner: current_user
		@personal_trainer.create_offering_creation(creator_id: @current_user_id)
		@personal_trainer.offering_administrations.create(administrator_id: @current_user_id)
		redirect_to @personal_trainer, notice: "Personal trainer page was created"

	end

  def destroy
		@user = current_user
		@personal_trainer = PersonalTrainer.find(params[:id])

		unless user_is_admin?(@personal_trainer) && user_created_this?(@personal_trainer); raise Errors::FlowError.new(personal_trainers_path); end

		@personal_trainer.create_activity :destroy, owner: current_user
		@personal_trainer.destroy

		redirect_to @personal_trainer
	end

	def show
		@personal_trainer = PersonalTrainer.find(params[:id])
                add_breadcrumb "Personal Trainers", personal_trainers_path, :title => "Back to the Index"
                add_breadcrumb @personal_trainer.title, personal_trainer_path(@personal_trainer)
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

		@json = @personal_trainer.location.to_gmaps4rails

		@likes = @personal_trainer.flaggings.with_flag(:like)
		@photo = Photo.new
		@album = @personal_trainer.album
		@owner = @personal_trainer
		@location = @personal_trainer.location
		@recent_activities =  PublicActivity::Activity.where(trackable_type: "PersonalTrainer", trackable_id: @personal_trainer.id)
		@recent_activities = @recent_activities.order("created_at desc")

        @grouped_happening_cases = grouped_happening_cases(@personal_trainer)
        @grouped_sessions = replace_with_happening(@grouped_happening_cases)

        @date = params[:date] ? Date.parse(params[:date]) : Date.today

        @collectives = @personal_trainer.collectives

	end

	def edit
		@personal_trainer = PersonalTrainer.find(params[:id])
		@personal_trainer.album ||= Album.new
		@location = @personal_trainer.location
		@photo = Photo.new
		@photo.title = "Logo"
	end

	def update
		@personal_trainer = PersonalTrainer.find(params[:id])
		@location = @personal_trainer.location
                        set_params_gmaps_flag :personal_trainer

		unless @personal_trainer.update_attributes(title: params[:personal_trainer][:title], descreption: params[:personal_trainer][:descreption]) && @location.update_attributes(city: params[:personal_trainer][:location][:city], custom_address_use: params[:personal_trainer][:location][:custom_address_use], longitude: params[:personal_trainer][:location][:longitude], latitude: params[:personal_trainer][:location][:latitude], gmap_use: params[:personal_trainer][:location][:gmap_use], custom_address: params[:personal_trainer][:location][:custom_address], gmaps: params[:personal_trainer][:location][:gmaps])
			raise Errors::FlowError.new(edit_personal_trainer_path(@personal_trainer), "There has been a problem with data entry.")
		end

		@personal_trainer.create_activity :update, owner: current_user
		redirect_to @personal_trainer, notice: "Personal Trainer page was updated"
	end

	private

		def user_must_be_admin?
			@personal_trainer = PersonalTrainer.find(params[:id])
			@user = current_user
			redirect_to(@personal_trainer) unless @personal_trainer.administrators.include?(@user)
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
