require 'net/http'
require 'json'
require 'tagfish/docker_uri'
require 'tagfish/api_call'

module Tagfish
  class DockerAPI

    attr_accessor :docker_uri
    attr_accessor :api_version
    attr_accessor :http_auth

    def initialize(docker_uri)
      @docker_uri = docker_uri
      retrieve_api_version_and_auth()
    end
    
    def retrieve_api_version_and_auth
      code = try_api('v1')
      if code != 200 
        code = try_api('v2')
      end
      if code == 401
        abort("Authentication failed, please `docker login <REGISTRY>` and try again.")
      elsif code != 200
        abort("API version not recognized")
      end
    end
    
    def try_api(version)
      code = APICall.new(ping_uri(version)).response_code
      if code == 200
        @api_version = version
      elsif code == 401
        code = init_auth(version)
        if code == 200
          @api_version = version
        end
      end
      return code
    end
    
    def init_auth(api_version)
      @http_auth = DockerHttpAuth.new(docker_uri.registry)
      if api_version == 'v2'
        code = APICall.new(ping_v2_uri).response_code(http_auth)
      elsif api_version == 'v1'
        code = APICall.new(ping_v1_uri).response_code(http_auth)
      end
    end
    
    def tags_v1
      APICall.new(tags_v1_uri).get_json(http_auth)
    end
    
    def tags_v2
      APICall.new(tags_v2_uri).get_json(http_auth)
    end
    
    def hash_v2(tag)
      APICall.new(hash_v2_uri(tag)).get_json(http_auth)
    end
    
    def catalog_v2
      APICall.new(catalog_v2_uri).get_json(http_auth)
    end
    
    def search_v1(keyword)
      APICall.new(search_v1_uri(keyword)).get_json(http_auth)
    end
    
    def base_uri
      "#{docker_uri.protocol}#{docker_uri.registry}"
    end
    
    def ping_uri(version)
      if version == 'v1'
        ping_v1_uri
      elsif version == 'v2'
        ping_v2_uri
      end
    end
    
    def ping_v2_uri
      "#{base_uri}/v2/"
    end
    
    def ping_v1_uri
      "#{base_uri}/v1/_ping"
    end
    
    def catalog_v2_uri
      "#{base_uri}/v2/_catalog"
    end
    
    def search_v1_uri(keyword)
      "#{base_uri}/v1/search?q=#{keyword}"  
    end
    
    def tags_v1_uri
      "#{base_uri}/v1/repositories/#{docker_uri.repository}/tags"
    end
    
    def tags_v2_uri
      "#{base_uri}/v2/#{docker_uri.repository}/tags/list"  
    end
    
    def hash_v2_uri(tag)
      "#{base_uri}/v2/#{docker_uri.repository}/manifests/#{tag}"
    end
    
  end
end
