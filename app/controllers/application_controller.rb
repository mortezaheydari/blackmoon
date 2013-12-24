class ApplicationController < ActionController::Base
  include SessionsHelper
  include LocationEvaluationHelper
  include PublicActivity::StoreController
  require 'errors/errors'

  protect_from_forgery

  	rescue_from Errors::FlowError, with: :flow_error_handler
  	rescue_from Errors::ValidationError, with: :validation_error_handler
    rescue_from Errors::LoudMalfunction, with: :load_malfunction_error_handler
    # rescue_from Errors::SilentMalfunction, with: :silent_malfunction_error_handler

	def name_is_valid?(name)
	  ["event","game", "user", "team", "venue", "personal_trainer", "group_training"].include? name.underscore
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

    # debugging methods and error handlers
	def flow_error_handler(exception)
        if exception.message.class.to_s == "String"
            flash[:alert] = exception.message
            respond_to do |format|
                format.html { redirect_to exception.redirect_object, alert: exception.message }
                format.js { render 'error/refresh_flash_message' }
            end
            return
        elsif exception.message.class.to_s == "Array"
            flash[:alert] = []
            flash[:alert] << "There was a problem with your request."
            exception.message.each do |msg|
                flash[:alert] << msg
            end
            respond_to do |format|
                format.html { redirect_to exception.redirect_object }
                format.js { render 'error/refresh_flash_message' }
            end
            return
        else
            flash[:alert] = []
            flash[:alert] << "There was a problem with your request."
            exception.message.full_messages.each do |msg|
                flash[:alert] << msg
            end
            respond_to do |format|
                format.html { redirect_to exception.redirect_object }
                format.js { render 'error/refresh_flash_message' }
            end
            return
        end
	end

    # Entrance of the following errors indicate a possibility of website malfunction.
    # Make sure to revise server, database and code in case any these codes were reported
    #   E0X01: could not create "offering_creation"
    #   E0X02: could not create "offering_administration"
    #   E0X03: problem with PublicActivity in create action, It will go alright except for lack of notification.
    #   E0X04: problem with PublicActivity in update action, It will go alright except for lack of notification.
    #   E0X05: could not create "act_membership"

    # event_controller
    #   X => 7
    # game_controller
    #   X => 8    
    # venue_controller    
    #   X => 2    
    # personal_trainer_controller    
    #   X => 3   
    # group_training_controller    
    #   X => 4
    # group_training_controller    
    #   X => 5

	def validation_error_handler(exception)
        if exception.message.class.to_s == "String"
            flash[:alert] = exception.message
            respond_to do |format|
                format.html { render exception.redirect_object }
                format.js { render 'error/refresh_flash_message' }
            end

            return
        elsif exception.message.class.to_s == "Array"
            flash[:alert] = []
            flash[:alert] << "There was a problem with your request."
            exception.message.each do |msg|
                flash[:alert] << msg
            end
            respond_to do |format|
                format.html { render exception.redirect_object }
                format.js { render 'error/refresh_flash_message' }
            end
            return
        else
            flash[:alert] = []
            flash[:alert] << "There was a problem with your request."
            exception.message.full_messages.each do |msg|
                flash[:alert] << msg
            end
            respond_to do |format|
                format.html { render exception.redirect_object }
                format.js { render 'error/refresh_flash_message' }
            end
            return
        end
	end

    def load_malfunction_error_handler(exception)
        if exception.message.class.to_s == "String"
            respond_to do |format|
                format.html { redirect_to exception.redirect_object, alert: exception.message }
                format.js { render 'error/refresh_flash_message' }
            end
            return
        elsif exception.message.class.to_s == "Array"
            flash[:alert] = []
            flash[:alert] << "There was a problem with your request. Please report this problem in case it occurs again."
            exception.message.each do |msg|
                flash[:alert] << msg
            end
            respond_to do |format|
                format.html { redirect_to exception.redirect_object }
                format.js { render 'error/refresh_flash_message' }
            end
            return
        else
            flash[:alert] = []
            flash[:alert] << "There was a problem with your request. Please report this problem in case it occurs again."
            exception.message.full_messages.each do |msg|
                flash[:alert] << msg
            end
            respond_to do |format|
                format.html { redirect_to exception.redirect_object }
                format.js { render 'error/refresh_flash_message' }
            end
            return
        end
    end

    # Currently, being done manually
    # def silent_malfunction_error_handler(exception)
    #     logger.debug "\nWebsite Silent Malfunction:\n #{exception.message}\n"

    # end
    def silent_malfunction_error_handler(message)
        logger.debug "\nWebsite Silent Malfunction:\n #{message}\n"
    end


    def black_debug(variable={}, message="debuging...")
        logger.debug "\n"
        logger.debug "<<<<<<<<<<<<<<<<<-debug->>>>>>>>>>>>>>>>>-start\n"
        logger.debug "#{message}:\n"
        logger.debug "#{variable}\n"
        logger.debug "<<<<<<<<<<<<<<<<<-debug->>>>>>>>>>>>>>>>>-end\n"
        logger.debug "\n"
    end

    # -ended


end
