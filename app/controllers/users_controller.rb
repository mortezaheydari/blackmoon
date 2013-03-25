class UsersController < ApplicationController
  before_filter :authenticate_account!, only: [:edit, :update]

  include SessionsHelper

  def index
    @users = User.all
  end

  def show
  	@user = User.find(params[:id])
    @likes = @user.flaggings.with_flag(:like)
    @photo = Photo.new    
  end

  def edit
    @user = User.find(params[:id])
    if current_user == @user
        @user.profile ||= Profile.new
        @user.album ||= Album.new
        @date_of_birth = @user.profile.date_of_birth
    else
        redirect_to root_path
    end
  end

  def update
    @user = User.find(params[:id])
    if current_user == @user
        @user.profile.date_of_birth = date_helper_to_str(params[:date_of_birth])
        if @user.update_attributes(params[:user])
          flash[:success] = "Profile updated"
          redirect_to @user
        else
          render 'edit'
        end
     else
        redirect_to root_path
    end
  end

end
