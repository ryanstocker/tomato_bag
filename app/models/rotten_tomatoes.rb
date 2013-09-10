require 'httparty'
require 'json'
require 'cgi'
require 'recursive-open-struct'
require 'active_support' #test outside of Rails


module RottenTomatoes

  class Base < RecursiveOpenStruct; end

  class Client

    attr_writer :api_key

    RT_BASE_URL = 'http://api.rottentomatoes.com/api/public'
    RT_BASE_VERSION = '1.0'
    RT_MIME = 'json'

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
