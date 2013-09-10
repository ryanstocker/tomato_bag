class FlaggedMovie < ActiveRecord::Base
  belongs_to :user
  scope :wanted, -> { where(state: 'wanted') }

  def movie
    @movie ||= Movie.find(rt_movie_id)
  end
end
