module OfferingConcern
  extend ActiveSupport::Concern

  included do
	  ThisClass = set_this_class

	  def index
	    @these = ThisClass.all
	    @recent_activities =  PublicActivity::Activity.where(trackable_type: "#{@model_class}")
	    @recent_activities = @recent_activities.order("created_at desc")

	    set_these_variable
	  end

	  def new
	  	@this = ThisClass.new
	    @this.happening_case = HappeningCase.new
	    @date_and_time = Time.now
			
			set_this_variable
	  end

	  def create
	    @current_user_id = current_user.id
	    @this = ThisClass.new(params[@model_class.downcase.to_sym])
	    @this.team_participation ||= false
	    @this.album = Album.new

	    set_this_variable
	  		double_check(send("new_#{@model_class.downcase}_path"), "there has been a problem with data entry.") {
	  	@this.save }

	    params[:happening_case][:date_and_time] = date_helper_to_str(params[:date_and_time])

	    @this.create_happening_case(params[:happening_case])
	    @this.create_activity :create, owner: current_user
	    @this.create_offering_creation(creator_id: @current_user_id)
	    @this.offering_administrations.create(administrator_id: @current_user_id)

	    set_this_variable
	    redirect_to @this

	  end

	  def destroy
	  	@user = current_user
	  	@this = ThisClass.find(params[:id])
	    set_this_variable

	  		double_check(send("#{@model_class.downcase}s_path")) {
	  	user_is_admin?(@this) && user_created_this?(@this) }

	    @this.create_activity :destroy, owner: current_user

	  		double_check(@this) {
	  	@this.destroy }

			redirect_to(send("#{@model_class.downcase}s_path"))
	  end

	  def show
	  	@this = ThisClass.find(params[:id])
	    @likes = @this.flaggings.with_flag(:like)
	    @photo = Photo.new
	    @album = @this.album
	    @owner = @this
	    @recent_activities =  PublicActivity::Activity.where(trackable_type: "#{@model_class}", trackable_id: @this.id)
	    @recent_activities = @recent_activities.order("created_at desc")
	    # flaggings.each do |flagging|
	    #      @likes = []
	    #      @likes << flagging.flagger
	    # end
	    if @this.team_participation == false
	        @participator = @this.individual_participators
	    else
	        @participator = @this.team_participators
	    end
	    set_this_variable
	  end

	  def edit
	    @this = ThisClass.find(params[:id])
	    @date_and_time = @this.happening_case.date_and_time
	    @this.album ||= Album.new
	    @photo = Photo.new
	    @photo.title = "Logo"
	    set_this_variable
	    end

	  def update
	    @this = ThisClass.find(params[:id])

	    # @this.date_and_time = date_helper_to_str(params[:date_and_time])
	    params[:happening_case][:date_and_time] = date_helper_to_str(params[:date_and_time])

	    set_this_variable

	  		double_check(send("#{edit_@model_class.downcase}_path", @this)) {
	  	@this.update_attributes(params[@model_class.downcase.to_sym]) }

	    @this.create_activity :update, owner: current_user

	    set_this_variable
	    redirect_to @this, notice: "#{@model_class} was updated"

	  end

	#  def user_must_be_admin?
	#    @this = ThisClass.find(params[:id])
	#    @user = current_user
	#    redirect_to(@this) unless @this.administrators.include?(@user)
	#  end

  end
end