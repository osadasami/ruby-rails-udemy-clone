# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CoursesController, type: :request do
  let(:course) { create(:course, title: 'not my course') }
  let(:student) { create(:user, :student) }
  let(:admin) { create(:user, :admin) }

  context 'all' do
    describe '#index' do
      it 'renders page with all courses' do
        get courses_path
        expect(response).to be_successful
      end
    end

    describe '#show' do
      it 'renders page with the course' do
        get course_path(course)
        expect(response).to be_successful
      end
    end
  end

  context 'authorized' do
    let!(:purchased_course) { create(:course, :purchased, buyer: student, title: 'purchased course without review') }
    let!(:purchased_course_with_review) { create(:course, :purchased, buyer: student, with_review: true, title: 'purchased course with review') }

    before do
      sign_in(student)
    end

    describe '#purchased' do
      it 'opens page with purchased courses' do
        get purchased_courses_path
        expect(response).to be_successful
      end

      it 'shows purchased course' do
        get purchased_courses_path
        expect(response.body).to include(purchased_course.title)
      end

      it 'does not show non-purchased courses' do
        get purchased_courses_path
        expect(response.body).not_to include(course.title)
      end
    end

    describe '#pending_review' do
      it 'opens page with pending review courses' do
        get pending_review_courses_path
        expect(response).to be_successful
      end

      it 'shows pending review course' do
        get pending_review_courses_path
        expect(response.body).to include(purchased_course.title)
      end

      it 'does not show reviewed course' do
        get pending_review_courses_path
        expect(response.body).not_to include(purchased_course_with_review.title)
      end
    end
  end

  context 'admin' do
    before do
      sign_in(admin)
    end

    describe '#new' do
      it 'renders page to create course' do
        get new_course_path
        expect(response).to be_successful
      end
    end

    describe '#create' do
      it 'creates course and redirects to course page' do
        post courses_path, params: {course: attributes_for(:course)}
        expect(response).to redirect_to(course_path(Course.last))
        follow_redirect!
        expect(response.body).to include(Course.last.title)
      end
    end

    describe '#edit' do
      it 'opens page to edit course' do
        get edit_course_path(course)
        expect(response).to be_successful
      end
    end

    describe '#update' do
      it 'updates the course' do
        params = attributes_for(:course, title: 'updated course')
        patch course_path(course), params: {course: params}
        expect(response).to redirect_to(course_path(course))
        follow_redirect!
        expect(response.body).to include(params[:title])
      end
    end

    describe '#destroy' do
      it 'deletes the course' do
        delete course_path(course)
        expect(response).to redirect_to(courses_path)
        expect(Course.count).to eq(0)
      end
    end
  end

  context 'teacher' do
    let(:teacher) { create(:user, :teacher) }
    let(:teacher_with_course) { create(:user, :teacher, :with_course) }

    context 'all' do
      before do
        sign_in(teacher)
      end

      describe '#new' do
        it 'renders page to create course' do
          get new_course_path
          expect(response).to be_successful
        end
      end

      describe '#create' do
        it 'creates course' do
          post courses_path, params: {course: attributes_for(:course)}
          expect(response).to redirect_to(course_path(Course.last))
          follow_redirect!
          expect(response.body).to include(Course.last.title)
        end
      end
    end

    context 'course owner' do
      before do
        sign_in(teacher_with_course)
      end

      describe '#edit' do
        it 'renders page to edit own course' do
          get edit_course_path(teacher_with_course.courses.last)
          expect(response).to be_successful
        end
      end

      describe '#update' do
        it 'updates own course' do
          course = teacher_with_course.courses.last
          new_title = 'new title'
          patch course_path(course), params: {course: attributes_for(:course, title: new_title)}
          expect(response).to redirect_to(course_path(course))
          follow_redirect!
          expect(response.body).to include(new_title)
        end
      end

      describe '#destroy' do
        it 'deletes own course' do
          delete course_path(teacher_with_course.courses.last)
          expect(response).to redirect_to(courses_path)
          expect(teacher_with_course.courses.count).to eq(0)
        end
      end
    end

    context 'not the course owner' do
      before do
        sign_in(teacher)
      end

      describe '#edit' do
        it 'redirects to root path' do
          get edit_course_path(course)
          expect(response).to redirect_to(root_path)
        end
      end

      describe '#update' do
        it 'redirects to root path' do
          patch course_path(course), params: {course: attributes_for(:course, title: 'updated course')}
          expect(response).to redirect_to(root_path)
          expect(course.title).not_to include('updated course')
        end
      end

      describe '#destroy' do
        it 'redirects to root path' do
          delete course_path(course)
          expect(response).to redirect_to(root_path)
          expect(Course.count).to eq(1)
        end
      end
    end
  end

  context 'student' do
    before do
      sign_in(student)
    end

    describe '#new' do
      it 'redirects to root path' do
        get new_course_path
        expect(response).to redirect_to(root_path)
      end
    end

    describe '#create' do
      it 'redirects to root path' do
        post courses_path, params: {course: attributes_for(:course)}
        expect(response).to redirect_to(root_path)
        expect(Course.count).to eq(0)
      end
    end

    describe '#edit' do
      it 'redirects to root path' do
        get edit_course_path(course)
        expect(response).to redirect_to(root_path)
      end
    end

    describe '#update' do
      it 'redirects to root path' do
        new_title = 'updated title'
        patch course_path(course), params: {course: attributes_for(:course, title: new_title)}
        expect(response).to redirect_to(root_path)
        expect(Course.last.title).not_to eq(new_title)
      end
    end

    describe '#destroy' do
      it 'redirects to root_path' do
        delete course_path(course)
        expect(response).to redirect_to(root_path)
        expect(Course.count).to eq(1)
      end
    end
  end
end
