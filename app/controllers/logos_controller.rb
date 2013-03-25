class LogosController < ApplicationController

  def update
  	owner_type = params[:owner_type]
  	owner_id = params[:owner_id]
  	remove_logo = params[:remove_logo]

    if name_is_valid?(owner_type)
		@owner = owner_type.camelize.constantize.find_by_id(owner_id)
		# checking photo upload premission
		if owner_type == "user"
			redirect_to @owner, notice: 'you don\'t have premission to upload photos to this page.' unless @owner == current_user
		else
			redirect_to @owner, notice: 'you don\'t have premission to upload photos to this page.' unless @owner.administrators.include? current_user
		end

		@logo = @owner.logo
	    @photo = Photo.new(params[:photo])

	    if remove_logo == true
	      if @photo.uses.count == 1
	        if @photo.destroy
	          respond_to do |format|
	            format.html { redirect_to @owner, notice: 'Photo was successfully removed.' }
	            format.js
	          end
	        else
	        	@logo.photo_id = nil
	          redirect_to @owner, notice: 'error while removing the photo.'
	        end
	    else
	    	@logo.photo_id = @photo.id
	    end

		if @logo.save
		    respond_to do |format|
		        format.html { redirect_to @owner, notice: 'Photo was successfully added.' }
		        format.js
		    end
	    else
	        redirect_to @owner, notice: 'error while updating the photo.'
	    end
    else
        redirect_to root_path
    end
  end

  private

    def name_is_valid?(name)
      ["event","class","game", "user", "team"].include? name.downcase
    end

end
