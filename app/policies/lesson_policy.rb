class LessonPolicy < ApplicationPolicy
  def show?
    true
  end

  def edit?
    @user.has_role?(:admin) || @record.course.user == @user
  end

  def update?
    @user.has_role?(:admin) || @record.course.user == @user
  end

  def new?
    @user.has_role?(:admin) || @user.has_role?(:teacher)
  end

  def create?
    @user.has_role?(:admin) || @user.has_role?(:teacher)
  end

  def destroy?
    @user.has_role?(:admin) || @record.course.user == @user
  end
end
