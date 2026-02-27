class Api::V1::CompaniesController < Api::BaseController
  before_action :set_company, only: %i[show update destroy]
  before_action :authorize_company, only: %i[show update destroy]

  def index
    companies = policy_scope(Company)
    render json: serialized_companies(companies)
  end

  def show
    render json: serialized_company(@company)
  end

  def create
    company = current_user.companies.build(company_params)
    authorize company

    raise CompanyError.new(company) unless company.save
    render json: { message: ResourceMessages.for_success(:company, :created), company: serialized_company(company) }, status: :created
  end

  def update
    raise CompanyError.new(@company) unless @company.update(company_params)
    render json: { message: ResourceMessages.for_success(:company, :updated), company: serialized_company(@company) }
  end

  def destroy
    @company.destroy
    render json: { message: ResourceMessages.for_success(:company, :deleted) }
  end

  private

  def set_company
    @company = Company.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: ResourceMessages.for_error(:company, :not_found) }, status: :not_found
  end

  def company_params
    params.permit(:name, :industry, :website)
  end

  def authorize_company
    authorize @company
  end

  def serialized_company(company)
    CompanySerializer.new(company).serializable_hash.dig(:data, :attributes)
  end

  def serialized_companies(companies)
    companies.map { |company| serialized_company(company) }
  end
end
