class DvdsController < ApplicationController
  before_filter :load_wanted_movie_ids

  def new_releases
    params[:page] ||= 1
    @movies = rotten_tomatoes.new_dvd_releases(48,params[:page])
  end

  def upcoming_releases
    params[:page] ||= 1
    @movies = rotten_tomatoes.upcoming_dvd_releases(48, params[:page])
  end

end
