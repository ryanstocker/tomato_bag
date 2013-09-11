require 'spec_helper'

describe MoviesController do
  render_views

  let(:movie)  { Movie.new(mock_movie_attributes) }

  context 'when a user is not authenticated' do
    before do
      RottenTomatoes::Client.any_instance.stub(:find_movie).and_return(movie)
    end

    describe "GET 'show'" do
      before { get :show, :id => movie.id }
      it { response.should be_success }
    end

    describe "GET 'search'" do
      it "should allow guest access to searching" do
        get :search
        expect(response).to be_success
      end
    end
  end
end
