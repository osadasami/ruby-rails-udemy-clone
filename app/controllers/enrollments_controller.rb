# frozen_string_literal: true

class EnrollmentsController < ApplicationController
  before_action :set_enrollment, only: %i[show edit update destroy]

  # GET /enrollments or /enrollments.json
  def index
    @q = Enrollment.ransack(params[:q])
    if current_user.has_role?(:admin)
      @pagy, @enrollments = pagy(@q.result.includes(:user))
    else
      @pagy, @enrollments = pagy(
        @q
          .result
          .includes(:user)
          .where(user: current_user)
      )
    end
    authorize @enrollments
  end

  # GET /enrollments/1 or /enrollments/1.json
  def show; end

  # GET /enrollments/new
  def new
    course = Course.friendly.find(params[:course])

    if course.bought_by?(current_user)
      redirect_to course_path(course), notice: 'You are already enrolled'
    end

    if course.user == current_user
      redirect_to course_path(course), notice: 'You can not enroll to your own course'
    end
  end

  # GET /enrollments/1/edit
  def edit
    authorize @enrollment
  end

  # POST /enrollments or /enrollments.json
  def create
    course = Course.friendly.find(params[:course])

    if course.user == current_user
      redirect_to course_path(course), notice: 'You can not enroll to your own course.'
    elsif !course.price.zero?
      redirect_to courses_path, notice: 'Paid courses are not available yet.'
    else
      current_user.buy_course(course)
      redirect_to course_path(course), notice: 'You are enrolled!'
    end
  end

  # PATCH/PUT /enrollments/1 or /enrollments/1.json
  def update
    authorize @enrollment

    respond_to do |format|
      if @enrollment.update(enrollment_params)
        format.html { redirect_to enrollment_url(@enrollment), notice: 'Enrollment was successfully updated.' }
        format.json { render :show, status: :ok, location: @enrollment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @enrollment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /enrollments/1 or /enrollments/1.json
  def destroy
    authorize @enrollment
    @enrollment.destroy

    respond_to do |format|
      format.html { redirect_to enrollments_url, notice: 'Enrollment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_enrollment
    @enrollment = Enrollment.friendly.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def enrollment_params
    params.require(:enrollment).permit(:course_id, :user_id, :rating, :review)
  end
end
