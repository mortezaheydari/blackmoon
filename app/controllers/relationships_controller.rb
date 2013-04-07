class RelationshipsController < ApplicationController
  include SessionsHelper

	def create
		@user = User.find(params[:relationship][:followed_id])
		current_user.follow!(@user)
		@user.create_activity :create, owner: current_user, recipient: @user
		respond_to do |format|
			format.html { redirect_to @user }
			format.js
		end
	end

	def destroy
		@user = Relationship.find(params[:id]).followed
		current_user.unfollow!(@user)
		@user.create_activity :destroy, owner: current_user, recipient: @user		
		respond_to do |format|
			format.html { redirect_to @user }
			format.js
		end
	end

end
