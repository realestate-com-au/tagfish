require 'net/http'
require 'json'
require 'tagfish/docker_uri'
require 'tagfish/api_call'
require 'tagfish/tags'

module Tagfish
  class DockerRegistryVbothClient

    attr_accessor :docker_uri
    attr_accessor :http_auth

    def initialize(docker_uri)
      @docker_uri = docker_uri
      code = APICall.new(ping_uri).response_code
      if code == 401
        @http_auth = DockerHttpAuth.new(docker_uri.registry)
        code = APICall.new(ping_uri).response_code(http_auth)
      end
      if code == 401
        raise DockerRegistryClient::AuthenticationError, "Please `docker login <REGISTRY>` and try again"
      elsif code != 200
        raise DockerRegistryClient::APIVersionError, "Not recognized"
      end
    end
    
    def base_uri
      "#{docker_uri.protocol}#{docker_uri.registry}"
    end

  end
end
