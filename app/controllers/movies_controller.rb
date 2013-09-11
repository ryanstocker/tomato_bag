class MoviesController < ApplicationController
  before_filter :load_wanted_movie_ids

  def show
    @movie = rotten_tomatoes.find_movie(params[:id])
  end

  def search
    @movies = []
    @movies = rotten_tomatoes.search_movies(params[:q]) if params[:q].present?
  end
end
