class OfferingAdministrationsController < ApplicationController

	before_filter :authenticate_account!

	def create
    offering = params[:offering_type]
    user = User.find_by_id(params[:admin_id_added])
    offering_id = params[:offering_id]

    if name_is_valid?(user, offering)

    	offerings_administrating = user.send("#{offering}s_administrating")
			offering_to_administrate = offering.camelize.constantize.find_by_id(offering_id)

			if offering_to_administrate.administrators.include? current_user
        # todo: check user has the right rank					
				offerings_administrating << offering_to_administrate
			end
	    respond_to do |format|
	        format.html { redirect_to offering_to_administrate }
	        format.js
	    end
	  else
			redirect_to root	  	
		end
  end

	def destroy
    offering_type = params[:offering_type]
    user = User.find_by_id(params[:admin_id_deleted])
    offering_id = params[:offering_id]

    if name_is_valid?(user, offering)

			offering_to_remove_admin_from = offering_type.camelize.constantize.find_by_id(offering_id)

			if current_user_can_delete_admin?(user, offering_to_remove_admin_from)	
				administrations = user.offering_administrations.where(offering_type: offering_type, offering_id: offerign_id)		
				administrations.each.destroy unless administrations == []
			end

	    respond_to do |format|
	        format.html { redirect_to offering_to_remove_admin_from }
	        format.js
	    end
	  else
			redirect_to root	  	
		end  
	end


  private

    # checks if offerign name is valid for user
    # note: this function is controller specific
    def name_is_valid?(user, name)
      user.respond_to? "#{name}s_administrating" and ["event","class","game"].include? name
    end  

		def current_user_can_delete_admin?(admin, offering)
			# todo: add superadmin
			offering.administrators.include? current_user && (current_user? user or current_user? offering.creator )
		end
end
