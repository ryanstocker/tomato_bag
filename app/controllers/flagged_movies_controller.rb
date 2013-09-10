class FlaggedMoviesController < ApplicationController
  before_filter :authenticate_user!

  def create
    movie = rotten_tomatoes.find_movie(params[:movie_id])
    @flagged_movie = current_user.flagged_movies.build(state: 'wanted', rt_movie_id: movie.id, 
                                      rt_imdb_id: movie.imbd_id, poster_detailed_url: movie.poster,
                                      poster_original_url: movie.poster_large)
    if @flagged_movie.save
      flash[:notice] = "#{movie.title} successfully added to your wanted list"
      redirect_back_or_default root_url
    end
  end

  def destroy
    if flagged_movie = current_user.flagged_movies.where(rt_movie_id: params[:movie_id]).first.destroy
      flash[:notice] = "Movie removed from your wanted list"
      redirect_back_or_default movie_url(flagged_movie.rt_movie_id)
    end
  end
end
