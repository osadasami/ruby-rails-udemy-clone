# frozen_string_literal: true

class CoursePolicy < ApplicationPolicy
  def edit?
    @user.has_role?(:admin) || @record.user == @user
  end

  def update?
    @user.has_role?(:admin) || @record.user == @user
  end

  def new?
    @user.has_role?(:admin) || @user.has_role?(:teacher)
  end

  def create?
    @user.has_role?(:admin) || @user.has_role?(:teacher)
  end

  def destroy?
    @user.has_role?(:admin) || @record.user == @user
  end
end
