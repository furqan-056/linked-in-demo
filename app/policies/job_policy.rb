class JobPolicy < ApplicationPolicy
  def create?
    user.admin? || user.recruiter?
  end

  def update?
    create?
  end

  def destroy?
    create?
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
