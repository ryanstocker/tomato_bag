class ApplicationController < ActionController::Base
  def rotten_tomatoes
    RottenTomatoes.new(ENV['ROTTEN_TOMATOES_API_KEY'])
  end
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
end
