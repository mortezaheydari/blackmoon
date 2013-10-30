class LogosController < ApplicationController

  def update
	owner_type  = params[:owner_type]
	owner_id    = params[:owner_id]
	remove_logo = false
	remove_logo = true unless params[:remove_logo].nil?
	photo_exists = false
	photo_exists = true unless params[:photo_exists].nil?

		double_check {
	name_is_valid?(owner_type) }

	@owner = owner_type.camelize.constantize.find_by_id(owner_id)

	# checking photo upload premission
	if owner_type == "User"
			double_check(@owner, 'you don\'t have premission to upload photos to this page.') {
		@owner == current_user }
	else
			double_check(@owner, 'you don\'t have premission to upload photos to this page.') {
		@owner.administrators.include? current_user }
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
				double_check {@photo.save} }

		elsif @logo.photo.uses.count == 1
			double_check {@logo.photo.destroy}
			unless_photo_exists{
				@photo = Photo.new(params[:photo])
				double_check {@photo.save} }

		else
			unless_photo_exists{
				@photo = Photo.new(params[:photo])
				double_check {@photo.save} }
		end

		@logo.photo_id = @photo.id

			double_check(@owner, 'error while updating the photo.') {
		@logo.save }
		respond_to do |format|
			format.html { redirect_to @owner, notice: 'Photo was successfully added.' }
			format.js
		end
	end

  end

end

