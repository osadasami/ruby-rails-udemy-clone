class LessonPolicy < ApplicationPolicy
  def show?
    true
  end

  def edit?
    update?
  end

  def update?
    @user.has_role?(:admin) || @record.course.user == @user
  end

  def new?
    create?
  end

  def create?
    @user.has_role?(:admin) || @record.course.user == @user
  end

  def destroy?
    @user.has_role?(:admin) || @record.course.user == @user
  end
end
