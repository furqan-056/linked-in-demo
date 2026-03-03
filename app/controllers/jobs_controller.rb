class JobsController < ApplicationController
  include JobSearchable
  before_action :authenticate_user!

  def index
    @jobs = Job.search(params[:query].presence || "*", where: build_filters, page: params[:page] || 1, per_page: 9)

    respond_to do |format|
      format.turbo_stream { render partial: "jobs_list", locals: { jobs: @jobs } }
      format.html
    end
  end

  def show
    @job = Job.find(params[:id])
  end
end
