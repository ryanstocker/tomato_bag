class ApplicationController < ActionController::Base
  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected

  # strong parameters are done at the controller level in Rails 4
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
  end

  def store_location
    session[:return_to] = request.url
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def load_wanted_movie_ids
    @wanted_movie_ids = []
    @wanted_movie_ids = current_user.flagged_movies.wanted.pluck(:rt_movie_id) if user_signed_in?
  end


  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
end
