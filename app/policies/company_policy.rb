class CompanyPolicy < ApplicationPolicy
  def create?
    user.admin? || user.recruiter?
  end

  def update?
    user.admin? || record.user_id == user.id
  end

  def destroy?
    update?
  end

  def show?
    true
  end

  def index?
    true
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
