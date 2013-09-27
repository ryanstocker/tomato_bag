class MoviesController < ApplicationController
  before_filter :load_wanted_movie_ids

  def show
    @movie = Movie.find(params[:id])
  end

  def search
    if params[:q].present?
      @movies = Movie.search(params[:q])
    else
      @movies = []
    end
  end
end
