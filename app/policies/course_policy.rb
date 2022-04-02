class CoursePolicy < ApplicationPolicy
  def edit?
    @user.has_role?(:admin)
  end
end
