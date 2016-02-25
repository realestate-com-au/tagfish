require 'json'
require 'tagfish/tags'

module Tagfish
  class TagsLogic
    
    attr_reader :docker_api
    
    def initialize(docker_api)
      @docker_api = docker_api
    end
    
    def find_tags_by_repository(tags_only=false)
      if docker_api.api_version == 'v2'
        tags_list = tags_v2(tags_only)
      else
        tags_list = tags_v1
      end
      Tagfish::Tags.new(tags_list)
    end

    private

    def tags_v1
      tags_json = docker_api.tags_v1
      tags_v1_api(tags_json)
    end

    def tags_v1_api(api_response_data)
      case api_response_data
      when Hash
        api_response_data
      when Array
        api_response_data.reduce({}) do |images, tag|
          images.merge({tag["name"] => tag["layer"]})
        end
      else
        raise "unexpected type #{api_response_data.class}"
      end
    end

    def tags_v2(tags_only)
      tags = docker_api.tags_v2["tags"]
      if tags.nil?
        abort("No Tags found for this repository")
      end
      
      tags_with_hashes = tags.inject({}) do |dict, tag|
        if tags_only
          dict[tag] = "dummy_hash"
        else
          dict[tag] = docker_api.hash_v2(tag)["fsLayers"][0]["blobSum"]
        end
        dict
      end
    end
    
  end
end
