module ApplicationHelper
  include Pagy::Frontend

  def enrollment_button(user, course)
    if user == course.user
      return link_to 'View your course', course_path(course)
    end

    if course.bought_by?(user)
      return link_to 'Continue learning', course_path(course)
    end

    if !course.bought_by?(user) && course.price == 0
      return link_to 'Start learning for free', new_enrollment_path(course: course)
    end

    if !course.bought_by?(user) && course.price > 0
      return link_to "Buy for #{number_to_currency(course.price)}", new_enrollment_path(course: course)
    end
  end

  def review_button(user, course)
    return unless user && course.bought_by?(user)

    user_enrollment = course.enrollments.find_by(user: user)

    if user_enrollment&.review&.empty?
      link_to 'Review', edit_enrollment_path(user_enrollment)
    else
      link_to 'Your review', enrollment_path(user_enrollment)
    end
  end
end
