class Movie < RottenTomatoes::Base

  # this smells, but I was interested in having Movie behave a little
  # like an ActiveRecord object
  # When no api_key is specified, Client.new falls back to ENV variable
  def self.find(id)
    data = rotten_tomatoes_client.find_movie(id)
    data.present? ? Movie.new(data) : nil
  end

  def self.search(q)
    #movie_json(__method__)
    convert_to_movie_array(rotten_tomatoes_client.search_movies(q))
  end

  def self.convert_to_movie_array(data)
    data['movies'].present? ? data['movies'].map {|m| Movie.new(m)} : []
  end

  def self.new_dvd_releases(page=1)
    movie_json(__method__)
  end

  def self.movie_json(method)
    convert_to_movie_array(rotten_tomatoes_client.send(method, 48))
  end

  def self.upcoming_dvd_releases(page=1)
    movie_json(__method__)
  end

  def self.sort_by_rating(release_type)
    send(release_type).sort_by {|m| -m.ratings.critics_score}
  end

  def self.top_ten(release_type)
    sort_by_rating(release_type)[0..9]
  end

  def similar_movies
    movie_data = self.class.rotten_tomatoes_client.find_similar_movies(id)
    self.class.convert_to_movie_array(movie_data)
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

  private

    def self.rotten_tomatoes_client
      @@rt ||= RottenTomatoes::Client.new
    end
end
