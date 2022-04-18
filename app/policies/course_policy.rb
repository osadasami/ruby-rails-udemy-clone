# frozen_string_literal: true

class CoursePolicy < ApplicationPolicy
  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
        .joins(:enrollments)
        .where(enrollments: { user: user })
    end

    private

    attr_reader :user, :scope
  end

  def purchased?
    @user && (
      @user.has_role?(:admin) ||
      @user.has_role?(:teacher) ||
      @user.has_role?(:student)
    )
  end

  def pending_review?
    @user && (
      @user.has_role?(:admin) ||
      @user.has_role?(:teacher) ||
      @user.has_role?(:student)
    )
  end

  def my?
    @user && (
      @user.has_role?(:admin) ||
      @user.has_role?(:teacher)
    )
  end

  def new?
    @user && (
      @user.has_role?(:admin) ||
      @user.has_role?(:teacher)
    )
  end

  def create?
    @user && (
      @user.has_role?(:admin) ||
      @user.has_role?(:teacher)
    )
  end

  def edit?
    @user && (
      @user.has_role?(:admin) ||
      @record.user == @user
    )
  end

  def update?
    @user && (
      @user.has_role?(:admin) ||
      @record.user == @user
    )
  end

  def destroy?
    @user && (
      @user.has_role?(:admin) ||
      @record.user == @user
    )
  end
end
