require 'spec_helper'

describe FlaggedMoviesController do
  context 'when a user is not authenticated' do
    describe "POST 'create'" do
      before { post :create, :movie_id => '12345' }
      it { should redirect_to(new_user_session_path) }
    end
  end

  context 'when a user is authenticated' do
    let(:brutus)  { create(:user) }
    let(:movie)   { Movie.new(mock_movie_attributes) }

    before do
      sign_in brutus
      RottenTomatoes::Client.any_instance.stub(:find_movie).and_return(movie)
    end

    describe "POST 'create'" do
      before { post :create, :movie_id => movie.id }
      it { should redirect_to(root_url) }
    end

    describe "GET 'index'" do
      before { get :wanted }
      it { response.should be_success }
    end
  end
end
