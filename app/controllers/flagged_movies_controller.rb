class FlaggedMoviesController < ApplicationController
  before_filter :authenticate_user!

  def wanted
    @wanted_movies = current_user.flagged_movies.wanted
  end

  def create
    movie = rotten_tomatoes.find_movie(params[:movie_id])
    @flagged_movie = current_user.flagged_movies.build(state: 'wanted', rt_movie_id: movie.id,
                                      rt_imdb_id: movie.imbd_id, poster_detailed_url: movie.poster,
                                      poster_original_url: movie.poster_large, title: movie.title)
    if @flagged_movie.save
      flash[:notice] = "#{movie.title} successfully added to your wanted list"
      redirect_back_or_default root_url
    end
  end

  def destroy
    if @flagged_movie = current_user.flagged_movies.find(params[:id]).destroy
      respond_to do |format|
        format.html do
          flash[:notice] = "Movie removed from your wanted list"
          redirect_back_or_default root_url
        end
        format.js { flash.now[:notice] = "#{@flagged_movie.title} removed from your wanted list" }
      end
    end
  end
end
