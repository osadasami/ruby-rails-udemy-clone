require 'rails_helper'

RSpec.describe EnrollmentsController, type: :request do
  let(:enrollment) { create(:enrollment) }
  let(:admin) { create(:user, :admin) }
  let(:teacher) { create(:user, :teacher) }
  let(:student) { create(:user, :student) }
  let(:course) { create(:course) }
  let(:course_free) { create(:course, price: 0) }

  context 'guest' do
    describe '#index' do
      it 'redirects to login page' do
        get enrollments_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe '#new' do
      it 'redirects to login page' do
        get new_enrollment_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe '#create' do
      it 'redirects to login page' do
        post enrollments_path params: {enrollment: attributes_for(:enrollment)}
        expect(response).to redirect_to(new_user_session_path)
        expect(Enrollment.count).to eq(0)
      end
    end

    describe '#show' do
      it 'redirects to login page' do
        get enrollment_path(enrollment)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe '#edit' do
      it 'redirects to login page' do
        get edit_enrollment_path(enrollment)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe '#update' do
      it 'redirects to login page' do
        patch enrollment_path(enrollment), params: {enrollment: {rating: 1}}
        expect(response).to redirect_to(new_user_session_path)
        expect(Enrollment.last.rating).to be(nil)
      end
    end

    describe '#destroy' do
      it 'redirects to login page' do
        delete enrollment_path(enrollment)
        expect(response).to redirect_to(new_user_session_path)
        expect(Enrollment.count).to eq(1)
      end
    end
  end

  context 'admin' do
    let!(:course_enrolled) { create(:course, :purchased, buyer: admin) }
    let!(:course_created) { create(:course, user: admin) }
    let!(:course_not_my) { create(:course, :purchased, buyer: teacher, title: 'not my enrollment') }

    before do
      sign_in(admin)
    end

    describe '#index' do
      it 'opens page with all enrollments' do
        get enrollments_path
        expect(response).to be_successful
        expect(response.body).to include(course_not_my.title)
      end
    end

    describe '#new' do
      context 'not enrolled' do
        it 'opens page to create new enrollment' do
          get new_enrollment_path(course: course)
          expect(response).to be_successful
        end
      end

      context 'already enrolled' do
        it 'redirects to course page' do
          get new_enrollment_path(course: course_enrolled)
          expect(response).to redirect_to(course_path(course_enrolled))
          follow_redirect!
          expect(response.body).to include('You are already enrolled')
        end
      end

      context 'my coursse' do
        it 'redirect to course page' do
          get new_enrollment_path(course: course_created)
          expect(response).to redirect_to(course_path(course_created))
          follow_redirect!
          expect(response.body).to include('You can not enroll to your own course')
        end
      end
    end

    describe '#create' do
      context 'free course' do
        it 'creates new enrollment' do
          post enrollments_path, params: {course: course_free.slug}
          expect(response).to redirect_to(course_path(course_free))
          follow_redirect!
          expect(response.body).to include 'You are enrolled!'
        end
      end

      context 'paid course' do
        it 'redirects to courses page' do
          post enrollments_path, params: {course: course.slug}
          expect(response).to redirect_to(courses_path)
          follow_redirect!
          expect(response.body).to include 'Paid courses are not available yet.'
        end
      end

      context 'my course' do
        it 'redirects to course page' do
          post enrollments_path, params: {course: course_created.slug}
          expect(response).to redirect_to(course_path(course_created))
          follow_redirect!
          expect(response.body).to include 'You can not enroll to your own course.'
        end
      end
    end

    describe '#show' do
      it 'opens enrollemt page' do
        get enrollment_path(course_enrolled.enrollments.last)
        expect(response).to be_successful
      end
    end
    describe '#edit' do
      it 'opens pages to edit course' do
        get edit_enrollment_path(course_enrolled.enrollments.last)
        expect(response).to be_successful
      end
    end
    describe '#update' do
      it 'updates enrollment' do
        patch enrollment_path(course_enrolled.enrollments.last), params: {enrollment: attributes_for(:enrollment, rating: 5, review: 'super good')}
        expect(response).to redirect_to(enrollment_path(course_enrolled.enrollments.last))
        expect(course_enrolled.enrollments.last.rating).to eq(5)
        expect(course_enrolled.enrollments.last.review).to eq('super good')
      end
    end
    describe '#destroy' do
      it 'deletes enrollment' do
        delete enrollment_path(course_enrolled.enrollments.last)
        expect(response).to redirect_to enrollments_path
        expect(course_enrolled.enrollments.count).to eq(0)
      end
    end
  end

  context 'teacher' do
    let!(:course_enrolled) { create(:course, :purchased, buyer: teacher, title: 'My enrolled course') }
    let!(:course_created) { create(:course, user: teacher) }
    let!(:course_not_my) { create(:course, :purchased, buyer: admin, title: 'not my enrollment') }

    before do
      sign_in(teacher)
    end

    describe '#index' do
      it 'opens page with my enrollments' do
        get enrollments_path
        expect(response).to be_successful
      end
      it 'shows only my enrollments' do
        get enrollments_path
        expect(response.body).to include(course_enrolled.title)
      end
      it 'does not show not my enrollments' do
        get enrollments_path
        expect(response.body).not_to include(course_not_my.title)
      end
    end

    describe '#new' do
      context 'not enrolled' do
        it 'opens page to create new enrollment' do
          get new_enrollment_path(course: course)
          expect(response).to be_successful
        end
      end

      context 'already enrolled' do
        it 'redirects to course page' do
          get new_enrollment_path(course: course_enrolled)
          expect(response).to redirect_to(course_path(course_enrolled))
          follow_redirect!
          expect(response.body).to include('You are already enrolled')
        end
      end

      context 'my coursse' do
        it 'redirect to course page' do
          get new_enrollment_path(course: course_created)
          expect(response).to redirect_to(course_path(course_created))
          follow_redirect!
          expect(response.body).to include('You can not enroll to your own course')
        end
      end
    end

    describe '#create' do
      context 'free course' do
        it 'creates new enrollment' do
          post enrollments_path, params: {course: course_free.slug}
          expect(response).to redirect_to(course_path(course_free))
          follow_redirect!
          expect(response.body).to include 'You are enrolled!'
        end
      end

      context 'paid course' do
        it 'redirects to courses page' do
          post enrollments_path, params: {course: course.slug}
          expect(response).to redirect_to(courses_path)
          follow_redirect!
          expect(response.body).to include 'Paid courses are not available yet.'
        end
      end

      context 'my course' do
        it 'redirects to course page' do
          post enrollments_path, params: {course: course_created.slug}
          expect(response).to redirect_to(course_path(course_created))
          follow_redirect!
          expect(response.body).to include 'You can not enroll to your own course.'
        end
      end
    end
  end
end
