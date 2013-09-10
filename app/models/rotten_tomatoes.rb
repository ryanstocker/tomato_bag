require 'httparty'
require 'json'
require 'cgi'
require 'recursive-open-struct'
require 'active_support' #test outside of Rails
require 'singleton'


module RottenTomatoes

  # thought a configure block would be more Railsy (modeled from
  # thoughtbot's Clearance)
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :api_key

    def intialize
      @api_key = 'need_api_key'
    end
  end


  class Base < RecursiveOpenStruct; end

  class Api
    include Singleton
    attr_reader :api_key

    RT_BASE_URL = 'http://api.rottentomatoes.com/api/public'
    RT_BASE_VERSION = '1.0'
    RT_MIME = 'json'

    def initialize
      @api_key = RottenTomatoes.configuration.api_key
      @base_url = "#{RT_BASE_URL}/v#{RT_BASE_VERSION}"
      @list_url = @base_url + "/lists"
      @movie_info_url = @base_url + "/movies"
    end

    def new_dvd_releases(page_limit=16, page=1, country="US")
      data = get_url_as_json(new_dvds_url)
      data['movies'].present? ? data['movies'].map {|m| Movie.new(m)} : []
    end

    # http://api.rottentomatoes.com/api/public/v1.0/movies/770672122.json?apikey=
    def find_movie(id)
      data = get_url_as_json(movie_info_url(id))
      data.present? ? Movie.new(data) : nil
    end


      private

      def movie_info_url(id)
        @movie_info_url + "/#{id}.#{RT_MIME}?apikey=#{api_key}"
      end

      def new_dvds_url
        @list_url + "/dvds/new_releases.#{RT_MIME}?apikey=#{api_key}"
      end

      def get_url_as_json(url)
        resp = HTTParty.get(url)
        JSON.parse(resp.body) if resp.code == 200
      end
  end
end
