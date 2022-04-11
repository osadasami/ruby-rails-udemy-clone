# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[edit update show]

  def index
    authorize current_user
    @q = User.ransack(params[:q])
    @users = @q.result(distinct: true).order(created_at: :desc)
    @pagy, @users = pagy(@users)
  end

  def edit
    authorize current_user
  end

  def show; end

  def update
    authorize current_user

    if @user.update(user_params)
      redirect_to users_path, notice: 'User roles was successfully updated'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.friendly.find(params[:id])
  end

  def user_params
    params.require(:user).permit(role_ids: [])
  end
end
