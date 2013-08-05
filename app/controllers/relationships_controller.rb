class RelationshipsController < ApplicationController
  include SessionsHelper

	def create
		@user = User.find(params[:relationship][:followed_id])
		relationship = current_user.follow!(@user)
		relationship.create_activity :create, owner: current_user, recipient: @user
		respond_to do |format|
			format.html { redirect_to @user }
			format.js
		end
	end

	def destroy
		relationship = Relationship.find(params[:id])
		@user = relationship.followed
		relationship.create_activity :destroy, owner: current_user, recipient: @user		
		current_user.unfollow!(@user)
		respond_to do |format|
			format.html { redirect_to @user }
			format.js
		end
	end

end
