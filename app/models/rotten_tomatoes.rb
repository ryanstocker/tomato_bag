require 'httparty'
require 'json'
require 'cgi'
require 'recursive-open-struct'


module RottenTomatoes
  def self.new(key)
    RottenTomatoes::Api.new(key)
  end


  class Base < RecursiveOpenStruct; end

  class Api
    RT_BASE_URL = 'http://api.rottentomatoes.com/api/public'
    RT_BASE_VERSION = '1.0'
    RT_MIME = 'json'

    def initialize(api_key)
      @@base_url = "#{RT_BASE_URL}/v#{RT_BASE_VERSION}"
      @@list_url = @@base_url + "/lists"
      @@new_dvds_url = @@list_url + "/dvds/new_releases.#{RT_MIME}?apikey=#{api_key}"
    end

    def new_dvd_releases(page_limit=16, page=1, country="US")
      data = get_url_as_json(@@new_dvds_url)
      data['movies'].present? ? data['movies'].map {|m| Movie.new(m)} : []
    end

      private

      def get_url_as_json(url)
        resp = HTTParty.get(url)
        JSON.parse(resp.body) if resp.code == 200
      end
  end
end
