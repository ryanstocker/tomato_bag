require 'spec_helper'

describe Movie do
  let(:rt)                { RottenTomatoes::Client.new(api_key: '123') }

  let(:movie_id)    { 770672122 }
  let(:movie)       { Movie.find(movie_id) }
  let(:movie_file)  { File.read('spec/fixtures/movies/toy_story_3.json') }

  let(:new_releases)      { rt.new_dvd_releases }
  let(:new_releases_url)  { 'http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/new_releases.json?apikey=123&page=1&page_limit=48' }
  let(:new_releases_file) { File.read('spec/fixtures/new_releases.json') }

  before(:each) do
    stub_request(:get,
                 new_releases_url
                ).to_return(status: 200, body: new_releases_file)
  end

  before do
    stub_request(:get,
                 "http://api.rottentomatoes.com/api/public/v1.0/movies/770672122.json?apikey=123"
                ).to_return(status: 200, body: movie_file)
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

  describe ".genre" do
    it "returns the genres for the movie" do
      expect(movie.genres).to include('Comedy')
    end
  end

  describe ".similar_movies" do
    before do
      data = JSON.parse(File.read('spec/fixtures/similar_to_toy_story_3.json'))
      RottenTomatoes::Client.any_instance.should_receive(:find_similar_movies).and_return(data)
    end

    it "returns similar movies for the movie" do
      similar_movies = movie.similar_movies
      similar_movies.first.title.should eq("Up")
    end
  end

  describe '#top_ten_dvd_releases' do
    let(:sorted_movies) {Movie.sort_by_rating(:new_dvd_releases).map(&:ratings).map(&:critics_score)}

    it 'it returns 10 dvds' do
      expect(Movie.top_ten(:new_dvd_releases).length).to eq(10)
    end

    it "it sorts the movie by their RT freshness rating" do
      expect(sorted_movies[0..2]).to eq([96,95,87])
    end
  end

  describe ".poster_large" do
    it "returns the original poster" do
      movie.poster_large.should == "http://content6.flixster.com/movie/11/13/43/11134356_ori.jpg"
    end
  end

end
