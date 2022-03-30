class UsersController < ApplicationController
  def index
    # @users = User.order(created_at: :desc)
    @q = User.ransack(params[:q])
    @users = @q.result(distinct: true)
  end
end
