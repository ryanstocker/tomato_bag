class ApplicationController < ActionController::Base
  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected

  # strong parameters are done at the controller level in Rails 4
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
  end

  def rotten_tomatoes
    RottenTomatoes.new(ENV['ROTTEN_TOMATOES_API_KEY'])
  end

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
end
