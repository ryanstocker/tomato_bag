require 'spec_helper'

describe FlaggedMoviesController do
  render_views

  context 'when a user is not authenticated' do
    describe "POST 'create'" do
      before { post :create, :movie_id => '12345' }
      it { should redirect_to(new_user_session_path) }
    end
  end

  context 'when a user is authenticated' do
    let(:brutus)        { create(:user) }
    let(:movie)         { Movie.new(mock_movie_attributes) }
    let!(:flagged_movie) { create(:flagged_movie, :user => brutus, rt_movie_id: movie.id, state: 'watched') }

    before do
      sign_in brutus
      RottenTomatoes::Client.any_instance.stub(:find_movie).and_return(mock_movie_attributes)
      Movie.any_instance.stub(:find_movie).and_return(movie)
    end

    describe "GET 'wanted'" do
      it 'assigns @watched_movies' do
        get :watched
        expect(assigns(:watched_movies)).to eq([flagged_movie])
      end
    end

    describe "PUT 'update'" do
      before { put :update, id: flagged_movie.id, flagged_movie: { state: 'wanted'} }
      it "should assign @flagged_movie" do
        expect(assigns(:flagged_movie)).to eq(flagged_movie)
      end
    end

    describe "POST 'create'" do
      before { post :create, :movie_id => movie.id }
      it { should redirect_to(root_url) }
    end

    describe "DELETE 'destroy'" do
      before { delete :destroy, id: flagged_movie.id, movie_id: movie.id }
      it { should redirect_to(root_url) }
    end

    describe "GET 'index'" do
      before { get :wanted }
      it { response.should be_success }
    end
  end
end
