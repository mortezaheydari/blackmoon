class ApplicationController < ActionController::Base
  include SessionsHelper
  include LocationEvaluationHelper
  include PublicActivity::StoreController
  require 'errors/errors'

  protect_from_forgery

  	rescue_from Errors::FlowError, with: :flow_error_handler

	def name_is_valid?(name)
	  ["event","class","game", "user", "team", "venue", "personal_trainer", "group_training"].include? name.underscore
	end

	# find and assign, dose it without administration check,
	# whereas this_if_reachable might also consider (this.administrators.include? current_user).

	def find_and_assign this_type, this_id

		if ["user", "team", "event", "game", "venue", "personal_trainer", "group_training", "offering_session"].include? this_type.underscore and this_id
			this_type.camelize.constantize.find_by_id(this_id)
		else
			nil
		end
	end

	def this_if_reachable(this_type, this_id)
		unless this_type == "Collective"
			return false unless name_is_valid?(this_type)
		end
		this = this_type.constantize.find(this_id)
		return false unless this
        this
	end

	def owner_if_reachable(this_type, this_id)
		this = this_if_reachable(this_type, this_id)
		return false unless this
		if this_type == "Collective"
			return false unless this.owner.administrators.include? current_user
		else
			return false unless this.administrators.include? current_user
		end
		this
	end

	# -ended

	def flow_error_handler(exeption)
		redirect_to exeption.redirect_object, notice: exeption.message and return
	end

	# def handle_record_not_saved
	# 	redirect_to new_game_path, notice: "there has been a problem with data entry." and return
	# end

end
