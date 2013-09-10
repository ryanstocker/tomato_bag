module ApplicationHelper
  def freshness(movie)
    score = movie.ratings.critics_score
    if score > 60
      content_tag(:span, "Fresh (#{score})", class: 'label success')
    else
      content_tag(:span, "Rotten (#{score})", class: 'label alert')
    end
  end
end
