class Api::V1::CompaniesController < Api::BaseController
  before_action :set_company, only: %i[show update destroy]
  before_action :authorize_company, only: %i[show update destroy]

  def index
    companies = policy_scope(Company)
    render json: companies.map { |company| serialized_company(company) }
  end

  def show
    render json: serialized_company(@company)
  end

  def create
    company = current_user.companies.build(company_params)
    authorize company

    raise CompanyError.new(company) unless company.save
    render json: { message: 'Company created', company: serialized_company(company) }, status: :created
  end

  def update
    raise CompanyError.new(@company) unless @company.update(company_params)
    render json: { message: 'Company updated', company: serialized_company(@company) }
  end

  def destroy
    if @company.destroy
      render json: { message: 'Company deleted' }, status: :ok
    else
      render json: { error: 'Failed to delete company', status: :unprocessable_entity }
    end
  end

  private

  def set_company
    @company = Company.find(params[:id])
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
end
