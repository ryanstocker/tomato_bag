class FlaggedMovie < ActiveRecord::Base
  belongs_to :user
  scope :wanted,  -> { where(state: 'wanted') }
  scope :watched, -> { where(state: 'watched') }
  validates_uniqueness_of :rt_movie_id, scope: [:user_id]

  def movie
    @movie ||= Movie.find(rt_movie_id)
  end

  def watched!
    update_attribute(:state, 'watched')
  end

  def watched?
    state == 'watched'
  end

  def wanted?
    state == 'wanted'
  end
end
