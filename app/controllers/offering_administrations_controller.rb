class OfferingAdministrationsController < ApplicationController
            include SessionsHelper
	before_filter :authenticate_account!

def create
    offering_type = params[:offering_type]
    user = User.find_by_id(params[:admin_id_added])
    offering_id = params[:offering_id]

    if name_is_valid?(user, offering_type)

        offerings_administrating = user.send("#{offering_type}s_administrating")
        	offering_to_administrate = offering_type.camelize.constantize.find_by_id(offering_id)

        	if offering_to_administrate.administrators.include? current_user
            # todo: check user has the right rank
                offerings_administrating << offering_to_administrate
            end
            respond_to do |format|
                format.html { redirect_to offering_to_administrate }
                format.js
            end
    else
    	redirect_to  send("#{act_type}_path", offering_id)
    end
end

def destroy
    offering_type = params[:offering_type]
    user = User.find_by_id(params[:admin_id_deleted])
    offering_id = params[:offering_id]

    if name_is_valid?(user, offering_type)

        offering_to_remove_admin_from = offering_type.camelize.constantize.find_by_id(offering_id)

        if current_user_can_delete_admin?(user, offering_to_remove_admin_from)
            administrations = []
            administrations = user.offering_administrations.where(offering_type: offering_type.camelize , offering_id: offering_id)
            administrations.each do |a|
                a.destroy
                end unless administrations == []
            end

            respond_to do |format|
                format.html { redirect_to offering_to_remove_admin_from }
                format.js
            end
    else
        redirect_to send("#{act_type}_path", offering_id)
    end
end


  private

    # checks if offerign name is valid for user
    # note: this function is controller specific
    def name_is_valid?(user, name)
      user.respond_to? "#{name}s_administrating" and ["event","class","game"].include? name
    end

		# def current_user_can_delete_admin?(admin, offering)
		# 	# todo: add superadmin
		# 	user_is_admin?(offering) && (user_created_this?(offering) or current_user?(admin)) && offering.administrators.count > 1
		# end
end
