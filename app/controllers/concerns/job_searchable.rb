module JobSearchable
  extend ActiveSupport::Concern

  private

  def search_query
    params[:query].presence || "*"
  end

  def build_filters
    filters = { status: 'open' }
    filters[:location] = params[:location] if params[:location].present?
    filters[:company_industry] = params[:industry] if params[:industry].present?

    min = params[:min_salary].to_f
    max = params[:max_salary].to_f

    if min > 0 || max > 0
      filters[:salary] = { gte: min > 0 ? min : 0, lte: max > 0 ? max : Float::INFINITY }
    end

    filters
  end

  def build_sort
    case params[:sort_by]
    when 'salary_asc'  then { salary: :asc }
    when 'salary_desc' then { salary: :desc }
    when 'oldest' then { created_at: :asc }
    when 'newest' then { created_at: :desc }
    else  { _score: :desc }
    end
  end
end
