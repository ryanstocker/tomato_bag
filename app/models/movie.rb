class Movie < RottenTomatoes::Base

  def imdb_id
    alternate_ids.imdb
  end

  def poster
    posters.detailed
  end

  def poster_large
    posters.original
  end
end
