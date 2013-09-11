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

    private

    def load_wanted_movie_ids
      @wanted_movie_ids = []
      @wanted_movie_ids = current_user.flagged_movies.wanted.pluck(:rt_movie_id) if user_signed_in?
    end
end
