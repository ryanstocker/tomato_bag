require 'spec_helper'

describe User do

  let(:user)  { create(:user) }
  let(:movie) { Movie.new(mock_movie_attributes) }
  let!(:flagged_movie) { create(:flagged_movie, user: user, rt_movie_id: movie.id, state: 'wanted') }

  describe '.wanted_movie?' do
    it 'should return true for a wanted movie' do
      expect(user.wanted_movie?(movie)).to be_true
    end

    it 'should return false for a watched movie' do
      flagged_movie.update_attributes(state: 'watched')
      expect(user.wanted_movie?(movie)).to be_false
    end
  end
end
