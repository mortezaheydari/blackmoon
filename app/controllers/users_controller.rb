class UsersController < ApplicationController
  def index
    @users = User.all  	
  end

  def show
  	@user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id]) 
    @user.profile ||= Profile.new
    @date_of_birth = @user.profile.date_of_birth
  end

  def update
    @user = User.find(params[:id])
    @user.profile.date_of_birth = date_helper_to_str(params[:date_of_birth])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end  

	private
		def date_helper_to_str(date)
			"#{date[:year]}-#{date[:month]}-#{date[:day]}"
		end  
end
