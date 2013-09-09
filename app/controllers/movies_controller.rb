class MoviesController < ApplicationController
  def show
    @movie = rotten_tomatoes.find_movie(params[:id])
  end
end
