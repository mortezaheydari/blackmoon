class PagesController < ApplicationController
	include SessionsHelper

	before_filter :authenticate_account!, only: [:offering_management, :notification]

            add_breadcrumb "home", :root_path

	def home
		@account ||= Account.new
		@account.user ||= User.new
		@recent_activities =  PublicActivity::Activity.all(order: 'created_at desc')
	end

	def offering_management
	end

	def notification
		@recent_activities =  PublicActivity::Activity.where(recipient_type: "User", recipient_id: current_user.id)
		@recent_activities = @recent_activities.order("created_at desc")
	end

            def search
                @offerings = Game.all + Event.all + Venue.all + Team.all


                    @search = Sunspot.search([Game, Event, Venue, Team, GroupTraining, PersonalTrainer]) do
                        fulltext params[:search]
                        order_by(:updated_at, :desc)
                        facet(:offering_type)
                        with(:offering_type, params[:offering_type]) if params[:offering_type].present?
                        facet(:city)
                        with(:city, params[:city]) if params[:city].present?
                    end
                    @offerings = @search.results
                    @recent_activities =  PublicActivity::Activity.all(order: 'created_at desc')
            end

end
