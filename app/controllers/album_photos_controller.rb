class AlbumPhotosController < ApplicationController

	def create
		owner_type = params[:owner_type]
		owner_id = params[:owner_id]
		photo_title = params[:photo_title]

		if !name_is_valid?(owner_type); raise Errors::FlowError.new; end

		@owner = owner_type.camelize.constantize.find_by_id(owner_id)

		# checking photo upload premission
		if owner_type == "user"
			if @owner != current_user; raise Errors::FlowError.new(@owner, 'you don\'t have premission to upload photos to this page.'); end
		else
			if !@owner.administrators.include?(current_user); raise Errors::FlowError.new(@owner, 'you don\'t have premission to upload photos to this page.'); end
		end

		@album = @owner.album
		@photo = Photo.new(params[:photo])
		@album_photo = @photo.album_photos.build(album_id: @album.id)

		if photo_title == ""
			@album_photo.title = @photo.title
		else
			@album_photo.title = photo_title
		end

		if !@photo.save; raise Errors::FlowError.new(@owner, 'error while uploading the photo.'); end
		if !@album.save; raise Errors::FlowError.new(@owner, 'error while uploading the photo.'); end

		respond_to do |format|
			format.html { redirect_to @owner, notice: 'Photo was successfully added.' }
			format.js
		end
	end

	def destroy
		owner_type = params[:owner_type]
		owner_id = params[:owner_id]

		if !name_is_valid?(owner_type); raise Errors::FlowError.new; end

		@owner = owner_type.camelize.constantize.find_by_id(owner_id)

		# checking photo upload premission
		if owner_type == "user"
			if @owner != current_user; raise Errors::FlowError.new(@owner, 'you don\'t have premission edit this page.'); end
		else
			if !@owner.administrators.include? current_user; raise Errors::FlowError.new(@owner, 'you don\'t have premission edit this page.'); end
		end

		@album = @owner.album
		@album_photo = @album.album_photo.find_by_id(params[:album_photo_id])
		@photo = @album_photo.photo

		if @photo.uses.count == 1
			if !@photo.destroy; raise Errors::FlowError.new(@owner, 'error while removing the photo.'); end
		else
			if !@album_photo.destory; raise Errors::FlowError.new(@owner, 'error while removing the photo.'); end
		end
		respond_to do |format|
			format.html { redirect_to @owner, notice: 'Photo was successfully removed.' }
			format.js
		end
	end

	def update
		owner_type = params[:owner_type]
		owner_id = params[:owner_id]
		photo_title = params[:photo_title]

		if !name_is_valid?(owner_type); raise Errors::FlowError.new; end

		@owner = owner_type.camelize.constantize.find_by_id(owner_id)

		# checking photo upload premission
		if owner_type == "user"
			if @owner != current_user; raise Errors::FlowError.new(@owner, 'you don\'t have premission to upload photos to this page.'); end
		else
			if !@owner.administrators.include? current_user; raise Errors::FlowError.new(@owner, 'you don\'t have premission to upload photos to this page.'); end
		end

		@album_photo = PhotoAlbum.find_by_id(params[:album_photo_id])
		@photo = @album_photo.photo

		if photo_title == ""
			@album_photo.title = @photo.title
		else
			@album_photo.title = photo_title
		end

		if !@album_photo.save; raise Errors::FlowError.new(@owner, 'error while uploading the photo.'); end

		respond_to do |format|
			format.html { redirect_to @owner, notice: 'Photo was successfully added.' }
			format.js
		end
	end
	
end