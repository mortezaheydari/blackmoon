class TeamsController < ApplicationController
	include SessionsHelper
	before_filter :authenticate_account!, only: [:new, :create, :edit, :destroy, :like]
	before_filter :user_must_be_admin?, only: [:edit, :destroy]

			add_breadcrumb "home", :root_path
	def like

		@team = Team.find(params[:id])

		if current_user.flagged?(@team, :like)
			current_user.unflag(@team, :like)
			msg = "you now don't like this team."
		else
			current_user.flag(@team, :like)
			msg = "you now like this team."
		end

		respond_to do |format|
			format.html { redirect_to @team}
			format.js
		end
	end

	def like_cards

		@team = Team.find(params[:id])

		# current_user.unflag(@team, :like)
		current_user.toggle_flag(@team, :like)

		respond_to do |format|
			format.js { render 'shared/offering/like_team_cards', :locals => { offering: @team, style_id: params[:style_id], class_name: params[:class_name] } }
		end
	end


	def index
		add_breadcrumb "Teams", teams_path, :title => "Back to the Index"
                        @search = Sunspot.search(Team) do
                              fulltext params[:search]

                              # with(:price, params[:min_price].to_i..params[:max_price].to_i) if params[:max_price].present? && params[:min_price].present?
                              # with(:price).greater_than(params[:min_price].to_i) if !params[:max_price].present? && params[:min_price].present?
                              # with(:price).less_than(params[:max_price].to_i) if params[:max_price].present? && !params[:min_price].present?

                              # with(:condition, params[:condition]) if params[:condition].present?
                              facet(:sport)
                              with(:sport, params[:sport]) if params[:sport].present?

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
                            @teams = @search.results
		@recent_activities =  PublicActivity::Activity.where(trackable_type: "Team")
		@recent_activities = @recent_activities.order("created_at desc")
	end

	def new
		@team = Team.new
	end

	def create
		@current_user_id = current_user.id
		@team = Team.new(params[:team])
		@team.album = Album.new
		@team.save
		@team.create_act_creation(creator_id: @current_user_id)
		@team.act_administrations.create(administrator_id: @current_user_id)
		@team.act_memberships.create(member_id: @current_user_id)
		@team.create_activity :create, owner: current_user
		redirect_to @team
	end

	def destroy
		@user = current_user
		@team = Team.find(params[:id])
		if user_is_admin?(@team) && user_created_this?(@team)
			if !@team.destroy; raise Errors::FlowError.new(@team); end
			@team.create_activity :destroy, owner: current_user

			redirect_to @team
		else
			render 'index'
		end
	end

	def show
		@team = Team.find(params[:id])
		add_breadcrumb "Teams", teams_path, :title => "Back to the Index"
		add_breadcrumb @team.title, team_path(@team)
		@likes = @team.flaggings.with_flag(:like)
		@members = @team.members
		@photo = Photo.new
		@album = @team.album
		@owner = @team

		@recent_activities =  PublicActivity::Activity.where(trackable_type: "Team", trackable_id: @team.id)
		@recent_activities = @recent_activities.order("created_at desc")
	end

	def edit
		@team = Team.find(params[:id])
		@team.album ||= Album.new
		@photo = Photo.new
		@photo.title = "Logo"
	end

	def update
		@team = Team.find(params[:id])
		if @team.update_attributes(params[:team]) # should become more secure in future.
		@team.create_activity :update, owner: current_user
			redirect_to @team
		else
			render 'edit'
		end
	end

	private
		def user_must_be_admin?
			@team = Team.find(params[:id])
			@user = current_user
			redirect_to(@team) unless @team.administrators.include?(@user)
		end
end
