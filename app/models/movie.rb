class Movie < RottenTomatoes::Base

  def self.find(id)
    RottenTomatoes::Api.instance.find_movie(id)
  end

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
