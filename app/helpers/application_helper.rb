module ApplicationHelper
  def freshness(movie)
    score = movie.ratings.critics_score.to_i
    if score > 60
      content_tag(:span, "Fresh (#{score})", class: 'label success')
    else
      content_tag(:span, "Rotten (#{score})", class: 'label alert')
    end
  end

  def dvd_availability(date)
    today = Date.today
    dvd_date = Chronic.parse(date).to_date
    days = dvd_date - today
    today < dvd_date ? "Available in #{pluralize(days, 'day', 'days')}" : "Currently Available"
  end
end
