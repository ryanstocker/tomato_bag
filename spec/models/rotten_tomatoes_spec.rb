require 'spec_helper'

describe RottenTomatoes do

  let(:rt)            { RottenTomatoes.new(123) }
  let(:new_releases)  { rt.new_dvd_releases }

  before(:each) do
    stub_request(:get,
                 'http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/new_releases.json?apikey=123'
                ).to_return(status: 200, body: File.read('spec/fixtures/new_releases.json'))
  end

  context 'when viewing new dvd releases' do
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
end
