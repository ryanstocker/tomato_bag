class User < ActiveRecord::Base
  has_many :flagged_movies
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def wanted_movie?(movie)
    flagged_movies.where(rt_movie_id: movie.id, state: 'wanted').exists?
  end
end
