class DvdsController < ApplicationController
  before_filter :load_wanted_movie_ids

  def new_releases
    @movies = Movie.new_dvd_releases(params[:page])
  end

  def upcoming_releases
    @movies = Movie.upcoming_dvd_releases(params[:page])
  end

end
