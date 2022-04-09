class EnrollmentPolicy < ApplicationPolicy
  def index?
    @user.has_role?(:admin)
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
