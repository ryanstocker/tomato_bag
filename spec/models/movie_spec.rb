require 'spec_helper'

describe Movie do

  describe "#find" do
    before do
       stub_request(:get,
                 'http://api.rottentomatoes.com/api/public/v1.0/movies/770672122.json?apikey=123'
                ).to_return(status: 200, body: File.read('spec/fixtures/movies/toy_story_3.json'))
    end

    it "should return a movie object" do
      
    end
  end
end
