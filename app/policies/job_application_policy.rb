class JobApplicationPolicy < ApplicationPolicy
  def create?
    user.candidate?
  end

  def update?
    user.admin? || user.recruiter?
  end

  def show?
    true
  end

  def index?
    true
  end

  class Scope < Scope
    def resolve
      return scope.all if user.admin?

      if user.recruiter?
        scope.joins(:job).where(jobs: { company_id: user.company_ids })
      elsif user.candidate?
        scope.where(user_id: user.id)
      else
        scope.none
      end
    end
  end
end
