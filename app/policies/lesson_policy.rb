# frozen_string_literal: true

class LessonPolicy < ApplicationPolicy
  def show?
    @user.has_role?(:admin) || @record.course.user == @user || @record.course.bought_by?(user)
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
