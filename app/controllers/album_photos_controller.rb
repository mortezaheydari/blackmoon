class AlbumPhotosController < ApplicationController

  def create
  	owner_type = params[:owner_type]
  	owner_id = params[:owner_id]
    photo_title = params[:photo_title]

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
	    @album_photo = @photo.build_album_photo(album_id: @album.id)

      if photo_title == ""
        @album_photo.title = @photo.title
      else
        @album_photo.title = photo_title
      end

			if @photo.save
		      if @album.save
            respond_to do |format| 
    	        format.html { redirect_to @owner, notice: 'Photo was successfully added.' }
    	        format.js
            end
  	      else
  	        redirect_to @owner, notice: 'error while uploading the photo.'
  	      end			
        end
	    else
        redirect_to @owner, notice: 'error while uploading the photo.'
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
        if @photo.destroy
          respond_to do |format|           
            format.html { redirect_to @owner, notice: 'Photo was successfully removed.' }
            format.js   
          end
        else
          redirect_to @owner, notice: 'error while removing the photo.' 
        end
      else
        if @album_photo.destory 
          respond_to do |format|           
            format.html { redirect_to @owner, notice: 'Photo was successfully removed.' }
            format.js   
          end
        else
          redirect_to @owner, notice: 'error while removing the photo.' 
        end        
      end 

    else
        redirect_to root
    end
  end

  def update

    owner_type = params[:owner_type]
    owner_id = params[:owner_id]
    photo_title = params[:photo_title]

    if name_is_valid?(owner_type)
      @owner = owner_type.camelize.constantize.find_by_id(owner_id)     

      # checking photo upload premission
      if owner_type == "user"
        redirect_to @owner, notice: 'you don\'t have premission to upload photos to this page.' unless @owner == current_user
      else
        redirect_to @owner, notice: 'you don\'t have premission to upload photos to this page.' unless @owner.administrators.include? current_user
      end

      @album_photo = PhotoAlbum.find_by_id(params[:album_photo_id])     
      @photo = @album_photo.photo

      if photo_title == ""
        @album_photo.title = @photo.title
      else
        @album_photo.title = photo_title
      end
      
      if @album_photo.save
        respond_to do |format| 
          format.html { redirect_to @owner, notice: 'Photo was successfully added.' }
          format.js
        end
      else
        redirect_to @owner, notice: 'error while uploading the photo.'
      end   
    else
        redirect_to root
    end
  end

  private

    def name_is_valid?(name)
      ["event","class","game", "user"].include? name
    end	
end