class DvdsController < ApplicationController
  def new_releases
    @movies = rotten_tomatoes.new_dvd_releases
  end
end
