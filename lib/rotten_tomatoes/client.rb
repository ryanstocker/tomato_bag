require 'httparty'
require 'json'
require 'cgi'
require 'recursive-open-struct'
require 'active_support' #test outside of Rails


module RottenTomatoes

  class Client

    attr_writer :api_key

    RT_BASE_URL = 'http://api.rottentomatoes.com/api/public'
    RT_BASE_VERSION = '1.0'

    def initialize(options={})
      options.each do |k,v|
        send(:"#{k}=", v)
      end
      yield self if block_given?
      @base_url = "#{RT_BASE_URL}/v#{RT_BASE_VERSION}"
      @list_url = @base_url + "/lists"
      @movie_info_url = @base_url + "/movies"
    end

    def api_key
      if instance_variable_defined?(:@api_key)
        @api_key
      else
        ENV['ROTTEN_TOMATOES_API_KEY']
      end
    end

    def new_dvd_releases(page_limit=48, page=1, country="US")
      get_url_as_json(new_dvds_url(page_limit,page))
    end

    def upcoming_dvd_releases(page_limit=48, page=1, country="US")
      get_url_as_json(upcoming_dvds_url(page_limit,page))
    end

    def search_movies(q)
      get_url_as_json(movie_search_url(q))
    end

    # http://api.rottentomatoes.com/api/public/v1.0/movies/770672122.json?apikey=
    def find_movie(id)
      data = get_url_as_json(movie_info_url(id))
    end

    def find_similar_movies(id)
      data = get_url_as_json(similar_movies_url(id))
    end


      private

      def movie_search_url(q="")
        @movie_info_url + ".json?apikey=#{api_key}&q=#{CGI.escape(q)}"
      end

      def movie_info_url(id)
        @movie_info_url + "/#{id}.json?apikey=#{api_key}"
      end

      def similar_movies_url(id)
        @movie_info_url + "/#{id}/similar.json?apikey=#{api_key}"
      end

      def new_dvds_url(page_limit=16, page=1)
        @list_url + "/dvds/new_releases.json?apikey=#{api_key}&page_limit=#{page_limit}&page=#{page}"
      end

      def upcoming_dvds_url(page_limit=16, page=1)
        @list_url + "/dvds/upcoming.json?apikey=#{api_key}&page_limit=#{page_limit}&page=#{page}"
      end

      def get_url_as_json(url)
        Rails.cache.fetch(url, expires_in: 24.hours) do
          resp = HTTParty.get(url)
          JSON.parse(resp.body) if resp.code == 200
        end
      end
  end
end
