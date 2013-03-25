class ApplicationController < ActionController::Base
  include SessionsHelper
	include PublicActivity::StoreController

  protect_from_forgery
end
