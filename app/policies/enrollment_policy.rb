class EnrollmentPolicy < ApplicationPolicy
  def index?
    @user.has_role?(:admin)
  end

  def edit?
    @record.user == @user
  end

  def update?
    @record.user == @user
  end

  def destroy?
    @user.has_role?(:admin)
  end
end
