class LogosController < ApplicationController

  def update
  	owner_type = params[:owner_type]
  	owner_id = params[:owner_id]
  	remove_logo = params[:remove_logo]

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
            @photo = Photo.new(params[:photo])
            double_check {@photo.save}
            @logo.photo_id = @photo.id
        elsif @logo.photo.uses.count == 1
            double_check {@logo.photo.destroy}
            @photo = Photo.new(params[:photo])
            double_check {@photo.save}                 
            @logo.photo_id = @photo.id                
        else
            @photo = Photo.new(params[:photo])
            double_check {@photo.save}                
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

end
