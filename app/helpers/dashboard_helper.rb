module DashboardHelper
  def application_status_badge(app_status)
    case app_status
    when 'applied'
      "application-badge-applied"
    when 'accepted'
      "application-badge-accepted"
    when 'rejected'
      "application-badge-rejected"
    when 'reviewing'
      "application-badge-reviewing"
    else
      "application-badge-default"
    end
  end

  def applications_count_by_status(applications, status)
    applications.where(status: status).count
  end

  def dashboard_stat_cards
    cards = []

    if current_user.recruiter?
      cards << { title: 'Total Jobs', value: @jobs.count, bg_class: "bg-blue-50", text_class: "text-blue-600" }
      cards << { title: 'Total Applications', value: @applications.count, bg_class: "bg-green-50", text_class: "text-green-600" }
      cards << { title: 'Total Companies', value: @companies.count, bg_class: "bg-yellow-50", text_class: "text-yellow-600" }
    else
      cards << { title: 'Total Applications', value: @applications.count, bg_class: "bg-blue-50", text_class: "text-blue-600" }
      cards << { title: 'Applied', value: applications_count_by_status(@applications, "applied"), bg_class: "bg-green-50", text_class: "text-green-600" }
      cards << { title: 'Accepted', value: applications_count_by_status(@applications, "accepted"), bg_class: "bg-purple-50", text_class: "text-purple-600" }
      cards << { title: 'Rejected', value: applications_count_by_status(@applications, "rejected"), bg_class: "bg-red-50", text_class: "text-red-600" }
      cards << { title: 'Reviewing', value: applications_count_by_status(@applications, "reviewing"), bg_class: "bg-orange-50", text_class: "text-orange-600" }
    end

    cards
  end
end
