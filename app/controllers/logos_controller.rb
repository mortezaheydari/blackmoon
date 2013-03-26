class LogosController < ApplicationController

  def update
  	owner_type = params[:owner_type]
  	owner_id = params[:owner_id]
  	remove_logo = true unless params[:remove_logo].nil?
    photo_exists = true unless params[:photo_exists].nil?

    double_check_name_is_valid owner_type

	@owner = owner_type.camelize.constantize.find_by_id(owner_id)
	# checking photo upload premission
	if owner_type == "User"
		redirect_to @owner, notice: 'you don\'t have premission to upload photos to this page.' unless @owner == current_user
	else
		redirect_to @owner, notice: 'you don\'t have premission to upload photos to this page.' unless @owner.administrators.include? current_user
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
        if @logo.save
            respond_to do |format|
                format.html { redirect_to @owner, notice: 'Photo was successfully added.' }
                format.js
            end
        else
            redirect_to @owner, notice: 'error while updating the photo.'
        end
    end

  end

  private

    def name_is_valid?(name)
      ["event","class","game", "user", "team"].include? name.downcase
    end

    def double_check(&b)
        redirect_to @owner, notice: 'error' and return unless b.call == true
    end

    def double_check_name_is_valid(name)
      redirect_to rooth_path and return unless name_is_valid?(name)
    end    

    def unless_photo_exists(&b)
        if photo_exists
            b.call
        else 
            @photo = Photo.find_by_id(params[:photo_id])
        end
    end
end
photo_exists