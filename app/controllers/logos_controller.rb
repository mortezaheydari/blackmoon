class LogosController < ApplicationController

  def update
	owner_type  = params[:owner_type]
	owner_id    = params[:owner_id]
	remove_logo = false
	remove_logo = true unless params[:remove_logo].nil?
	photo_exists = false
	photo_exists = true unless params[:photo_exists].nil?

	if !name_is_valid?(owner_type); raise Errors::FlowError.new; end

	@owner = owner_type.camelize.constantize.find_by_id(owner_id)

	# checking photo upload premission
	if owner_type == "User"
		if @owner != current_user; raise Errors::FlowError.new(@owner, 'you don\'t have premission to upload photos to this page.'); end
	else
		if !@owner.administrators.include? current_user; raise Errors::FlowError.new(@owner, 'you don\'t have premission to upload photos to this page.'); end
	end

	@logo = @owner.logo

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
		end
	else

		if @logo.photo.nil?
			unless_photo_exists{
				@photo = Photo.new(params[:photo])
				if !@photo.save; raise Errors::FlowError.new; end }

		elsif @logo.photo.uses.count == 1
			if !@logo.photo.destroy; raise Errors::FlowError.new; end
			unless_photo_exists{
				@photo = Photo.new(params[:photo])
				if !@photo.save; raise Errors::FlowError.new; end }

		else
			unless_photo_exists{
				@photo = Photo.new(params[:photo])
				if !@photo.save; raise Errors::FlowError.new; end }
		end

		@logo.photo_id = @photo.id

		if !@logo.save; raise Errors::FlowError.new(@owner, 'error while updating the photo.'); end

		respond_to do |format|
			format.html { redirect_to @owner, notice: 'Photo was successfully added.' }
			format.js
		end
	end

  end

	private

	def unless_photo_exists(&b)
		if @photo_exists
			@photo = Photo.find_by_id(params[:photo_id])
		else
			b.call
		end
	end

end

