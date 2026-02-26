class Api::V1::CompaniesController < Api::BaseController
  before_action :set_company, only: [:show, :update, :destroy]
  before_action :authorize_company, only: [:show, :update, :destroy]

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

    raise CompanyError, company.errors.full_messages.join(", ") unless company.save

    render json: { message: "Company created", company: serialized_company(company) }, status: :created
  end

  def update
    raise CompanyError, @company.errors.full_messages.join(", ") unless @company.update(company_params)

    render json: { message: "Company updated", company: serialized_company(@company) }
  end

  def destroy
    @company.destroy
    render json: { message: "Company deleted" }
  end

  private

  def set_company
    @company = Company.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Company not found" }, status: :not_found
  end

  def company_params
    params.permit(:name, :industry, :website)
  end

  def authorize_company
    authorize @company
  end

  def serialized_company(company)
    CompanySerializer.new(company).serializable_hash[:data][:attributes]
  end

  def serialized_companies(companies)
    companies.map { |company| serialized_company(company) }
  end
end
