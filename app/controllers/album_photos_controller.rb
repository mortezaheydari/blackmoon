class AlbumPhotosController < ApplicationController

  def create
  	owner_type = params[:owner_type]
  	owner_id = params[:owner_id]

    if name_is_valid?(owner_type)
		@owner = owner_type.camelize.constantize.find_by_id(owner_id)    	
			# checking photo upload premission
			if owner_type == "user"
				redirect_to @owner, notice: 'you don\'t have premission to upload photos to this page.' unless @owner == current_user
			else
				redirect_to @owner, notice: 'you don\'t have premission to upload photos to this page.' unless @owner.administrators.include? current_user
			end

			@album = @owner.album
	    @photo = Photo.new(params[:photo])
	    @photo.build_album_photo(album_id: @album.id)

			if @photo.save
		    respond_to do |format| 
		      if @album.save
		        format.html { redirect_to @owner, notice: 'Photo was successfully added.' }
		        format.js
		      else
		        redirect_to @owner, notice: 'error while uploading the photo.'
		      end			
				end
	    end

    else
        redirect_to root
    end
  end

  def destroy
    owner_type = params[:owner_type]
    owner_id = params[:owner_id]

    if name_is_valid?(owner_type)
      @owner = owner_type.camelize.constantize.find_by_id(owner_id)     

      # checking photo upload premission
      if owner_type == "user"
        redirect_to @owner, notice: 'you don\'t have premission edit this page.' unless @owner == current_user
      else
        redirect_to @owner, notice: 'you don\'t have premission edit this page.' unless @owner.administrators.include? current_user
      end

      @album = @owner.album
      @album_photo = @album.album_photo.find_by_id(params[:album_photo_id])
      @photo = @album_photo.photo

      if @photo.uses.count == 1
        @photo.destroy
      else
        @album_photo.destory 
      end 
      respond_to do |format| 
        if @album.save
          format.html { redirect_to @owner, notice: 'Photo was successfully removed.' }
          format.js   
      end
    else
        redirect_to root
    end
  end

  private
    # checks if offering name is valid for user
    # note: this function is controller specific
    def name_is_valid?(name)
      ["event","class","game", "user"].include? name
    end	
end