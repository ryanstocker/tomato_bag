class FlaggedMoviesController < ApplicationController
  before_filter :authenticate_user!

  def wanted
    @wanted_movies = current_user.flagged_movies.wanted
  end

  def watched
    @watched_movies = current_user.flagged_movies.watched
  end

  def create
    params[:state] ||= 'wanted'
    movie = rotten_tomatoes.find_movie(params[:movie_id])
    @flagged_movie = current_user.flagged_movies.build(state: params[:state], rt_movie_id: movie.id,
                                      rt_imdb_id: movie.imbd_id, poster_detailed_url: movie.poster,
                                      poster_original_url: movie.poster_large, title: movie.title)
    if @flagged_movie.save
      flash[:notice] = "#{movie.title} successfully added to your wanted list"
      redirect_back_or_default root_url
    end
  end

  def update
    @flagged_movie = current_user.flagged_movies.find(params[:id])
    new_state = params[:flagged_movie][:state] == 'watched' ? 'wanted' : 'watched'

    if @flagged_movie.update_attribute(:state, params[:flagged_movie][:state])
      respond_to do |format|
        format.html do
          flash[:notice] = "#{@flagged_movie.title} was moved to your #{new_state} list"
          redirect_back_or_default root_url
        end
        format.js { flash.now[:notice] = "#{@flagged_movie.title} was moved to your #{new_state} list" }
      end
    end
  end

  def destroy
    if params[:movie_id].present?
      @flagged_movie = current_user.flagged_movies.where(rt_movie_id: params[:movie_id]).first
    else
      @flagged_movie = current_user.flagged_movies.find(params[:id])
    end
    if @flagged_movie.destroy
      respond_to do |format|
        format.html do
          flash[:notice] = "Movie removed from your wanted list"
          redirect_back_or_default root_url
        end
        format.js { flash.now[:notice] = "#{@flagged_movie.title} removed from your wanted list" }
      end
    end
  end

  private

  def flagged_movie_params
    params.require(:flagged_movie).permit(:state)
  end
end
