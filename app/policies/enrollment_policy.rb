# frozen_string_literal: true

class EnrollmentPolicy < ApplicationPolicy
  def index?
    @user.has_role?(:admin) || @user.has_role?(:teacher) || @user.has_role?(:student)
  end

  def show?
    @user.has_role?(:admin) || @record.user == @user
  end

  def edit?
    update?
  end

  def update?
    @user.has_role?(:admin) || @record.user == @user
  end

  def destroy?
    @user.has_role?(:admin)
  end
end
