module JobSearchable
  extend ActiveSupport::Concern

  private

  def search_query
    params[:query].presence || "*"
  end

  def build_filters
    filters = { status: "open" }
    filters[:location] = params[:location] if params[:location].present?
    filters[:company_industry] = params[:industry] if params[:industry].present?

    if params[:min_salary].present? || params[:max_salary].present?
      filters[:salary] = {
        gte: params[:min_salary]&.to_f || 0,
        lte: params[:max_salary]&.to_f || Float::INFINITY
      }
    end

    filters
  end

  def build_sort
    case params[:sort_by]
    when "salary_asc"  then { salary: :asc }
    when "salary_desc" then { salary: :desc }
    when "oldest"      then { created_at: :asc }
    when "newest"      then { created_at: :desc }
    else                    { _score: :desc }
    end
  end
end
