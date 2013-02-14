class ActAdministrationsController < ApplicationController

    include SessionsHelper

	def create
		act_type = params[:offering_type]
    user = User.find_by_id(params[:admin_id_added])
    act_id = params[:offering_id]

    if name_is_valid?(user, act_type)

			acts_administrating = user.send("#{act_type}s_administrating")
			act_to_administrate = act_type.camelize.constantize.find_by_id(act_id)

			if act_to_administrate.administrators.include? current_user
			  # todo: check user has the right rank
			      acts_administrating << act_to_administrate
			end
		  respond_to do |format|
		      format.html { redirect_to act_to_administrate }
		      format.js
		  end
    else
    	redirect_to  send("#{act_type}_path", act_id)
    end
	end

	def destroy
    act_type = params[:offering_type]
    user = User.find_by_id(params[:admin_id_deleted])
    act_id = params[:offering_id]

    if name_is_valid?(user, act_type)

      act_to_remove_admin_from = act_type.camelize.constantize.find_by_id(act_id)

      if current_user_can_delete_admin?(user, act_to_remove_admin_from)
        administrations = []
        administrations = user.act_administrations.where(act_type: act_type.camelize , act_id: act_id)
        administrations.each do |a|
          a.destroy
          end unless administrations == []
        end

        respond_to do |format|
          format.html { redirect_to act_to_remove_admin_from }
          format.js
        end
    else
      redirect_to send("#{act_type}_path", act_id)
    end

	end

  private

    # checks if offerign name is valid for user
    # note: this function is controller specific
    def name_is_valid?(user, name)
      user.respond_to? "#{name}s_administrating" and ["event","class","game"].include? name
    end

		# def current_user_can_delete_admin?(admin, act)
		# 	# todo: add superadmin
		# 	user_is_admin?(act) && (user_created_this?(act) or current_user?(admin)) && act.administrators.count > 1
		# end

end