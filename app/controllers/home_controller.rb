class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  def index
    @courses = Course.limit(5)
    @latest_courses = Course.order(created_at: :desc).limit(3)
  end
end
