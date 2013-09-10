require 'spec_helper'

describe FlaggedMovie do
  let(:user)          { create(:user) }
  let(:wanted_movie)  { create(:flagged_movie, state: 'wanted', user: user) }

  describe '.wanted!' do
    it "should change the state to watched" do
      expect{wanted_movie.watched!}.to change{wanted_movie.state}.from('wanted').to('watched')
    end
  end
end
