class Movie < RottenTomatoes::Base

  # this smells, but I was interested in having Movie behave a little
  # like an ActiveRecord object
  # When no api_key is specified, Client.new falls back to ENV variable
  def self.find(id)
    data = rotten_tomatoes_client.find_movie(id)
    data.present? ? Movie.new(data) : nil
  end

  def self.search(q)
    convert_to_movie_array(rotten_tomatoes_client.search_movies(q))
  end

  def self.convert_to_movie_array(data)
    data['movies'].present? ? data['movies'].map {|m| Movie.new(m)} : []
  end

  def self.new_dvd_releases(page=1)
    convert_to_movie_array(rotten_tomatoes_client.new_dvd_releases(48,page))
  end

  def self.upcoming_releases(page=1)
    convert_to_movie_array(rotten_tomatoes_client.upcoming_releases(48,page))
  end

  def self.top_ten_dvd_releases(page=1)
    convert_to_movie_array(rotten_tomatoes_client.new_dvd_releases(48,page))#[0..9]
  end

  def self.sort_by_rating(release_type)
    releases = send(release_type)
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
