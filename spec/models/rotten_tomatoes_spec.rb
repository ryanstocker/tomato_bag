require 'spec_helper'

describe RottenTomatoes do

  let(:rt)                { RottenTomatoes::Client.new(api_key: '123') }

  context 'new dvd releases' do

    let(:new_releases)      { rt.new_dvd_releases }
    let(:new_releases_url)  { 'http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/new_releases.json?apikey=123' }
    let(:new_releases_file) { File.read('spec/fixtures/new_releases.json') }

    before(:each) do
      stub_request(:get,
                   new_releases_url
                  ).to_return(status: 200, body: new_releases_file)
    end

    it 'should use the correct URI' do
      new_releases
      WebMock.should have_requested(:get, new_releases_url)
    end

    it 'should return an array of Movies' do
      new_releases.should be_an(Array)
      new_releases.each do |nr|
        nr.should be_a(Movie)
      end
    end

    it 'should return the default number of movies in a page' do
      new_releases.size.should == 16
    end
  end

  context 'movies' do

    let(:movie_id)        { 770672122 } #Toy Story 3
    let(:movie_info_url)  { "http://api.rottentomatoes.com/api/public/v1.0/movies/#{movie_id}.json?apikey=123" }
    let(:toy_story_3)     { File.read('spec/fixtures/movies/toy_story_3.json') }
    let(:movie)           { rt.find_movie(movie_id) }

    describe 'getting info for a single movie' do

      before(:each) do
        stub_request(:get,
                      movie_info_url
                    ).to_return(status: 200, body: toy_story_3)
      end

      it 'should use the correct URI' do
        rt.find_movie(movie_id)
        WebMock.should have_requested(:get, movie_info_url)
      end

      it 'should have the correct title' do
        movie.title.should == "Toy Story 3"
      end

      it 'should have an original poster' do
        movie.posters.original.should == 'http://content6.flixster.com/movie/11/13/43/11134356_ori.jpg'
      end

      it 'should have an imdb id' do
        movie.alternate_ids.imdb.should_not be_nil
      end
    end
  end
end
