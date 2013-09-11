require 'spec_helper'

describe RottenTomatoes do

  let(:rt)                { RottenTomatoes::Client.new(api_key: '123') }

  context 'new dvd releases' do

    let(:new_releases)      { rt.new_dvd_releases }
    let(:new_releases_url)  { 'http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/new_releases.json?apikey=123&page=1&page_limit=48' }
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

  # probably a good opportunity to try out rspec shared examples.
  # I don't mind verbosity in specs for clarity, though
  context 'upcoming dvd releases' do
    let(:upcoming_releases)       { rt.upcoming_dvd_releases }
    let(:upcoming_releases_url)   { 'http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/upcoming.json?apikey=123&page=1&page_limit=48' }
    let(:upcoming_releases_file)  { File.read('spec/fixtures/upcoming_releases.json') }

    before(:each) do
      stub_request(:get,
                   upcoming_releases_url
                  ).to_return(status: 200, body: upcoming_releases_file)
    end

    it 'should use the correct URI' do
      upcoming_releases
      WebMock.should have_requested(:get, upcoming_releases_url)
    end

     it 'should return an array of Movies' do
      upcoming_releases.should be_an(Array)
      upcoming_releases.each do |ur|
        ur.should be_a(Movie)
      end
    end

    it 'should return the default number of movies in a page' do
      upcoming_releases.size.should == 16
    end

  end

  context 'searching' do
    let(:search_term)         { 'Hobbit' }
    let(:search_movies)       { rt.search_movies(search_term) }
    let(:search_movies_url)   { 'http://api.rottentomatoes.com/api/public/v1.0/movies.json?apikey=123&q=Hobbit' }
    let(:search_movies_file)  { File.read('spec/fixtures/hobbit_search.json') }

    describe 'searching for a movie' do
      before(:each) do
        stub_request(:get,
                      search_movies_url
                    ).to_return(status: 200, body: search_movies_file)
      end

      it 'should use the correct URI' do
        search_movies
        WebMock.should have_requested(:get, search_movies_url)
      end

      it 'should return the correct number of results' do
        expect(search_movies.size).to eq(6)
      end

      it 'should have returned results with titles' do
        search_movies.each do |sm|
          expect(sm.title).to_not be_blank
        end
      end
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
