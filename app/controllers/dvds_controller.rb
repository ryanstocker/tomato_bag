class DvdsController < ApplicationController
  before_filter :load_wanted_movie_ids

  def new_releases
    @movies = Movie.new_dvd_releases(params[:page])
  end

  def upcoming_releases
    @movies = Movie.upcoming_dvd_releases(params[:page])
  end

  def top_ten_new_releases
    @release_type = 'New'
    @movies = Movie.top_ten(:new_dvd_releases)
    render 'top_ten'
  end

  def top_ten_upcoming_releases
    @release_type = 'Upcoming'
    @movies = Movie.top_ten(:upcoming_dvd_releases)
    render 'top_ten'
  end

end
