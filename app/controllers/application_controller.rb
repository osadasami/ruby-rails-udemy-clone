class ApplicationController < ActionController::Base
	include PublicActivity::StoreController

	include Pundit::Authorization
	protect_from_forgery
	rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

	before_action :authenticate_user!
	after_action :update_user_online

	private

	def user_not_authorized
		flash[:alert] = 'You are not authorized to perform this action.'
		redirect_to(request.referrer || root_path)
	end

	def update_user_online
		current_user.try :touch
	end
end
