require 'spec_helper'

describe FlaggedMovie do
  let(:user)            { create(:user) }
  let(:wanted_movie)    { create(:flagged_movie, state: 'wanted', user: user, rt_movie_id: movie_id) }
  let(:watched_movie)   { create(:flagged_movie, state: 'watched', user: user) }
  let(:movie_id)        { 770672122 }

  describe '.wanted!' do
    it "should change the state to watched" do
      expect{wanted_movie.watched!}.to change{wanted_movie.state}.from('wanted').to('watched')
    end
  end

  describe '.wanted?' do
    it "should be true when wanted" do
      wanted_movie.should be_wanted
    end

    it "should be false when not wanted" do
      wanted_movie.state = 'watched'
      wanted_movie.should_not be_wanted
    end
  end

  describe '.wantched?' do
    it "should be true when watched" do
      watched_movie.should be_watched
    end

    it "should be false when not watched" do
      watched_movie.state = 'wanted'
      watched_movie.should_not be_watched
    end
  end

  describe '#find' do

    let(:movie)       { Movie.find(movie_id) }
    let(:movie_file)  { File.read('spec/fixtures/movies/toy_story_3.json') }

    before do
      stub_request(:get,
                   "http://api.rottentomatoes.com/api/public/v1.0/movies/770672122.json?apikey=123"
                  ).to_return(status: 200, body: movie_file)
    end

    it 'should find the movie' do
      wanted_movie.movie.id.should == movie.id
    end
  end

end
