# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CoursesController, type: :request do
  let(:user) { User.create!(
    email: 'test@test.com',
    password: 'test@test.com',
    confirmed_at: DateTime.now
  ) }

  let(:another_user) { User.create!(
    email: 'test1@test.com',
    password: 'test1@test.com',
    confirmed_at: DateTime.now
  ) }

  let(:course_params) {
    {
      title: 'my super course',
      description: 'description',
      language: 'English',
      level: 'Beginner',
      price: 100,
      description_short: 'description_short',
      user: user
    }
  }

  let(:course) { Course.create!(course_params) }

  describe '#index' do
    context 'guest' do
      it 'works' do
        get courses_path
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe '#show' do
    context 'guest' do
      it 'shows course page' do
        get course_path(course)
        expect(response).to be_successful
        expect(response.body).to include('my super course')
      end
    end

    context 'admin' do
      it 'shows course page' do
        user.add_role(:admin)
        sign_in(user)
        get course_path(course)
        expect(response).to be_successful
      end
    end

    context 'teacher' do
      it 'shows course page' do
        user.add_role(:teacher)
        sign_in(user)
        get course_path(course)
        expect(response).to be_successful
      end
    end

    context 'student' do
      it 'shows course page' do
        user.add_role(:student)
        sign_in(user)
        get course_path(course)
        expect(response).to be_successful
      end
    end
  end

  describe '#new' do
    context 'guest' do
      it 'redirect to login page' do
        get new_course_path
        expect(response).to redirect_to(new_user_session_path)
        follow_redirect!
        expect(response.body).to include('You need to sign in or sign up before continuing.')
      end
    end

    context 'admin' do
      it 'works' do
        user.add_role(:admin)
        sign_in(user)
        get new_course_path
        expect(response).to have_http_status(:ok)
      end
    end

    context 'teacher' do
      it 'works' do
        user.add_role(:teacher)
        sign_in(user)
        get new_course_path
        expect(response).to have_http_status(:ok)
      end
    end

    context 'student' do
      it 'redirects to root path' do
        user.add_role(:student)
        sign_in(user)
        get new_course_path
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include('You are not authorized to perform this action.')
      end
    end
  end

  describe '#create' do
    context 'guest' do
      it 'redirect to root path' do
        post courses_path, params: {}
        expect(response).to redirect_to(new_user_session_path)
        follow_redirect!
        expect(response.body).to include('You need to sign in or sign up before continuing.')
      end
    end

    context 'admin' do
      it 'creates the course and redirects to it' do
        user.add_role(:admin)
        sign_in(user)
        post courses_path, params: { course: course_params }
        expect(response).to redirect_to(course_path(Course.last))
        follow_redirect!
        expect(response.body).to include('Course was successfully created.')
      end
    end

    context 'teacher' do
      it 'creates the course and redirects to it' do
        user.add_role(:teacher)
        sign_in(user)
        post courses_path, params: { course: course_params }
        expect(response).to redirect_to(course_path(Course.last))
        follow_redirect!
        expect(response.body).to include('Course was successfully created.')
      end
    end

    context 'student' do
      it 'redirects to root path' do
        sign_in(user)
        post courses_path, params: { course: course_params }
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include('You are not authorized to perform this action.')
      end
    end
  end

  describe '#edit' do
    context 'guest' do
      it 'redirects to sign in page' do
        get edit_course_path(course)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'admin' do
      it 'opens edit page' do
        user.add_role(:admin)
        sign_in(user)
        get edit_course_path(course)
        expect(response).to be_successful
        expect(response.body).to include('my super course')
      end
    end

    context 'teacher' do
      context 'my course' do
        it 'opens edit page' do
          user.add_role(:teacher)
          course.user = user
          sign_in(user)
          get edit_course_path(course)
          expect(response).to be_successful
        end
      end

      context 'not my course' do
        it 'redirects to root path' do
          user.add_role(:teacher)
          course.update!(user: another_user)
          sign_in(user)
          get edit_course_path(course)
          expect(response).to redirect_to(root_path)
          follow_redirect!
          expect(response.body).to include('You are not authorized to perform this action.')
        end
      end
    end

    context 'student' do
      it 'redirects to root path' do
        another_user.add_role(:student)
        sign_in(another_user)
        get edit_course_path(course)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe '#update' do
    context 'guest' do
      it 'redirects to sign in page' do
        patch course_path(course), params: {course: course_params}
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'admin' do
      it 'updates course' do
        user.add_role(:admin)
        sign_in(user)
        patch course_path(course), params: {course: course_params.merge(title: 'updated course title')}
        expect(response).to redirect_to(course_path(course))
        follow_redirect!
        expect(response.body).to include('Course was successfully updated.')
        expect(response.body).to include('updated course title')
      end
    end

    context 'teacher' do
      context 'my course' do
        it 'updates course' do
          user.add_role(:teacher)
          sign_in(user)
          patch course_path(course), params: {course: course_params.merge(title: 'updated course title')}
          expect(response).to redirect_to(course_path(course))
          follow_redirect!
          expect(response.body).to include('Course was successfully updated.')
          expect(response.body).to include('updated course title')
        end
      end

      context 'not my course' do
        it 'redirects to root path' do
          another_user.add_role(:teacher)
          sign_in(another_user)
          patch course_path(course), params: {course: course_params.merge(title: 'updated course title')}
          expect(response).to redirect_to(root_path)
          follow_redirect!
          expect(response.body).to include('You are not authorized to perform this action.')
          get course_path(course)
          expect(response.body).not_to include('updated course title')
        end
      end

      context 'student' do
        it 'redirects to root path' do
          another_user.add_role(:student)
          sign_in(another_user)
          patch course_path(course), params: {course: course_params.merge(title: 'updated course title')}
          expect(response).to redirect_to(root_path)
          follow_redirect!
          expect(response.body).to include('You are not authorized to perform this action.')
          get course_path(course)
          expect(response.body).not_to include('updated course title')
        end
      end
    end
  end

  describe '#destroy' do
    context 'guest' do
      it 'redirects to login page' do
        delete course_path(course)
        expect(response).to redirect_to(new_user_session_path)
        get course_path(course)
        expect(response).to be_successful
      end
    end
    context 'admin' do
      it 'deletes course and redirects to courses_path' do
        user.add_role(:admin)
        sign_in(user)
        delete course_path(course)
        expect(response).to redirect_to(courses_path)
        follow_redirect!
        expect(response.body).to include('Course was successfully destroyed.')
      end
    end
    context 'teacher' do
      context 'my course' do
        it 'deletes course and redirects to courses_path' do
          user.add_role(:teacher)
          sign_in(user)
          delete course_path(course)
          expect(response).to redirect_to(courses_path)
          follow_redirect!
          expect(response.body).to include('Course was successfully destroyed.')
        end
      end
      context 'not my course' do
        it 'does not delete course and redirects to root path' do
          another_user.add_role(:teacher)
          sign_in(another_user)
          delete course_path(course)
          expect(response).to redirect_to(root_path)
          follow_redirect!
          expect(response.body).to include('You are not authorized to perform this action.')
          get course_path(course)
          expect(response).to be_successful
        end
      end
    end
    context 'student' do
      it 'does not delete the course and redirect to root path' do
        another_user.add_role(:student)
        sign_in(another_user)
        delete course_path(course)
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include('You are not authorized to perform this action.')
        get course_path(course)
        expect(response).to be_successful
      end
    end
  end

  describe '#purchased' do
    context 'guest' do
      it 'redirects to sign in page' do
        get purchased_courses_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
    context 'admin' do
      it 'opens page with purchased courses' do
        another_user.add_role(:admin)
        sign_in(another_user)
        expect { another_user.buy_course(course) }.to change { another_user.enrollments.count }.by(1)
        get purchased_courses_path
        expect(response.body).to include('my super course')
      end
    end
    context 'teacher' do
      it 'opens page with purchased courses' do
        another_user.add_role(:teacher)
        sign_in(another_user)
        expect { another_user.buy_course(course) }.to change { another_user.enrollments.count }.by(1)
        get purchased_courses_path
        expect(response.body).to include('my super course')
      end
    end
    context 'student' do
      it 'opens page with purchased courses' do
        another_user.add_role(:student)
        sign_in(another_user)
        expect { another_user.buy_course(course) }.to change { another_user.enrollments.count }.by(1)
        get purchased_courses_path
        expect(response.body).to include('my super course')
      end
    end
  end

  describe '#pending_review' do
    context 'guest' do
      it 'redirects to sign in page' do
        get purchased_courses_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
    context 'admin' do
      it 'opens page with pending reviews' do
        another_user.add_role(:admin)
        sign_in(another_user)
        expect { another_user.buy_course(course) }.to change { another_user.enrollments.pending_review.count }.by(1)
        get pending_review_courses_path
        expect(response.body).to include('my super course')
      end
    end
    context 'teacher' do
      it 'opens page with pending reviews' do
        another_user.add_role(:teacher)
        sign_in(another_user)
        expect { another_user.buy_course(course) }.to change { another_user.enrollments.pending_review.count }.by(1)
        get pending_review_courses_path
        expect(response.body).to include('my super course')
      end
    end
    context 'student' do
      it 'opens page with pending reviews' do
        another_user.add_role(:student)
        sign_in(another_user)
        expect { another_user.buy_course(course) }.to change { another_user.enrollments.pending_review.count }.by(1)
        get pending_review_courses_path
        expect(response.body).to include('my super course')
      end
    end
  end

  describe '#my' do
    context 'guest' do
      it 'redirects to sign in page' do
        get purchased_courses_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
    context 'admin' do
      it 'opens my courses' do
        user.add_role(:admin)
        sign_in(user)
        expect(course.user).to eq(user)
        expect(user.courses.count).to eq(1)
        get my_courses_path
        expect(response).to be_successful
        expect(response.body).to include('my super course')
      end
    end
    context 'teacher' do
      it 'opens my courses' do
        user.add_role(:teacher)
        sign_in(user)
        expect(course.user).to eq(user)
        expect(user.courses.count).to eq(1)
        get my_courses_path
        expect(response).to be_successful
        expect(response.body).to include('my super course')
      end
    end
    context 'student' do
      it 'redirects to root path' do
        another_user.add_role(:student)
        sign_in(another_user)
        get my_courses_path
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
