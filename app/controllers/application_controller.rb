class ApplicationController < ActionController::Base
	include PublicActivity::StoreController 
	before_action :authenticate_user!
end
