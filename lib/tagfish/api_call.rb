require 'tagfish/docker_http_auth'
require 'tagfish/api_error'
require 'tagfish/api_response'

module Tagfish
  class APICall

    attr_accessor :uri
    attr_accessor :http
    attr_accessor :request
    attr_accessor :http_auth
    attr_accessor :debug

    def initialize (debug = false)
      @debug = debug
      @auth = nil
    end

    def get(uri_string)
      @uri = URI.parse(uri_string)
      @http = Net::HTTP.new(uri.host, uri.port)
      @http.use_ssl = true if uri.port == 443
      @http.set_debug_output($stderr) if debug
      @request = Net::HTTP::Get.new(uri.request_uri)
      if http_auth
        @request.basic_auth(http_auth.username, http_auth.password)
      end
      http_response = http.request(request)
      APIResponse.new(http_response)
    end

    def get!(uri_string)
      response = get(uri_string)
      if response.code != 200
        raise APIError, "call to '#{uri_string}' failed with #{response.code}"
      end
      response
    end

    def auth(registry)
      @http_auth = DockerHttpAuth.new(registry)
    end

  end
end
