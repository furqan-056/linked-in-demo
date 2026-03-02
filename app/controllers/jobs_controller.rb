class JobsController < ApplicationController
  before_action :authenticate_user!

  def index
    @jobs = policy_scope(Job).order(created_at: :desc).page(params[:page]).per(9)
  end

  def show
    @job = Job.find(params[:id])
  end
end
