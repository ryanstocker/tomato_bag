require 'spec_helper'

describe Movie do

  let(:movie_id) { 770672122 }
  let(:movie)    { Movie.find(movie_id) }

  before do
     stub_request(:get,
               'http://api.rottentomatoes.com/api/public/v1.0/movies/770672122.json?apikey=123'
              ).to_return(status: 200, body: File.read('spec/fixtures/movies/toy_story_3.json'))
  end

  describe ".imdb_id" do
    it "returns the imdb_id" do
      movie.imdb_id.should == '0435761'
    end
  end

  describe ".poster" do
    it "returns the detailed poster" do
      movie.poster.should == "http://content6.flixster.com/movie/11/13/43/11134356_det.jpg"
    end
  end

  describe ".poster_large" do
    it "returns the original poster" do
      movie.poster_large.should == "http://content6.flixster.com/movie/11/13/43/11134356_ori.jpg"
    end
  end

end
