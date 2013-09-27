require 'spec_helper'

describe MoviesController do
  render_views

  let(:movie)  { Movie.new(mock_movie_attributes) }
  let(:search_term)         { 'Hobbit' }
  let(:search_movies)       { rt.search_movies(search_term) }
  let(:search_movies_url)   { 'http://api.rottentomatoes.com/api/public/v1.0/movies.json?apikey=123&q=Hobbit' }
  let(:search_movies_file)  { File.read('spec/fixtures/hobbit_search.json') }

  context 'when a user is not authenticated' do
    before do
      RottenTomatoes::Client.any_instance.stub(:find_movie).and_return(mock_movie_attributes)
      Movie.any_instance.stub(:find).and_return(movie)
    end

    describe "GET 'show'" do
      before { get :show, :id => movie.id }
      it { response.should be_success }
    end

    describe "GET 'search'" do
      before(:each) do
        stub_request(:get,
                     search_movies_url
                    ).to_return(status: 200, body: search_movies_file)
      end
      it "should allow guest access to searching" do
        get :search
        expect(response).to be_success
      end

      it "should allow guest access to searching by name" do
        get :search, q: 'Hobbit'
        expect(response).to be_success
      end
    end
  end
end
