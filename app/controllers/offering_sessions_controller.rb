class OfferingSessionsController < ApplicationController
  
  include SessionsHelper
  before_filter :authenticate_account!, only: [:new, :create, :edit, :destroy, :like]  
  before_filter :user_must_be_admin?, only: [:edit, :destroy]

  def create
    owner_type = params[:owner_type]
    owner_id = params[:owner_id]
    
      double_check {
    name_is_valid?(owner_type) }

    # find owner object
    @owner = owner_type.camelize.constantize.find_by_id(owner_id)

    # checking permission
      double_check(@owner, 'you don\'t have premission for adding sessions to this offering.') {
    @owner.administrators.include?(current_user) }   

    #? new collections or an existing one?

    ## no collection

    ## new collection.

      # get collection details

      # create collection (redirect if not)

      # set collection_id

    ## existing one.

      # get collection_id

      # double_check collection exists, (redirect if not)

      # set collection_id
 
    #? single or multiple?

    ## single

      # create it

    ## multiple

      # double_check repeat request is proper, (redirect if not)

      # create them (redirect if not)

    # render

  end

  def update # session
     
  end

  def destroy
    
  end

  def assign_collection
    
  end

  def user_must_be_admin?
    @event = Event.find(params[:id])
    @user = current_user
    redirect_to(@event) unless @event.administrators.include?(@user)
  end

end
