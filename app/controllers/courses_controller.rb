# frozen_string_literal: true

class CoursesController < ApplicationController
  before_action :set_course, only: %i[show edit update destroy]

  # GET /courses or /courses.json
  def index
    @q = Course.ransack(params[:q])
    @courses = @q.result.includes(:user).with_all_rich_text
    @pagy, @courses = pagy(@courses)
  end

  def purchased
    @q = Course.ransack(params[:q])
    @courses = @q.result
                 .includes(:user)
                 .joins(:enrollments)
                 .where(enrollments: { user: current_user })
                 .with_all_rich_text
    @pagy, @courses = pagy(@courses)

    render :index
  end

  def pending_review
    @q = Course.ransack(params[:q])
    @courses = @q.result
                 .includes(:user)
                 .joins(:enrollments)
                 .merge(
                   Enrollment.pending_review.where(user: current_user)
                 )
                 .with_all_rich_text
    @pagy, @courses = pagy(@courses)

    render :index
  end

  def my
    @q = Course.ransack(params[:q])
    @courses = @q.result.includes(:user).with_all_rich_text.where(user: current_user)
    @pagy, @courses = pagy(@courses)

    render :index
  end

  # GET /courses/1 or /courses/1.json
  def show; end

  # GET /courses/new
  def new
    @course = Course.new
    authorize @course
  end

  # GET /courses/1/edit
  def edit
    authorize @course
  end

  # POST /courses or /courses.json
  def create
    @course = Course.new(course_params)
    authorize @course
    @course.user = current_user

    respond_to do |format|
      if @course.save
        format.html { redirect_to course_url(@course), notice: 'Course was successfully created.' }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses/1 or /courses/1.json
  def update
    authorize @course
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to course_url(@course), notice: 'Course was successfully updated.' }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1 or /courses/1.json
  def destroy
    authorize @course
    @course.destroy

    respond_to do |format|
      format.html { redirect_to courses_url, notice: 'Course was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_course
    @course = Course.friendly.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def course_params
    params.require(:course).permit(:title, :description, :description_short, :language, :level, :price)
  end
end
