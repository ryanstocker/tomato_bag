class Movie < RottenTomatoes::Base

  # this smells, but I was interested in having Movie behave a little
  # like an ActiveRecord object
  # When no api_key is specified, Client.new falls back to ENV variable
  def self.find(id)
    RottenTomatoes::Client.new.find_movie(id)
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
