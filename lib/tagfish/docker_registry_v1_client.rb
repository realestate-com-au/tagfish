require 'tagfish/docker_registry_vboth_client'

module Tagfish
  class DockerRegistryV1Client < DockerRegistryVbothClient
    
    def api_version
      'v1'
    end
    
    def tag_names
      tag_map.tag_names
    end

    def tag_map
      tags_list = tags_api(tags)
      Tagfish::Tags.new(tags_list)
    end
    
    private

    def tags
      api_call.get(tags_uri).json
    end
        
    def tags_api(api_response_data)
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
    
    def ping_uri
      "#{base_uri}/v1/_ping"
    end
    
    def tags_uri
      "#{base_uri}/v1/repositories/#{docker_uri.repository}/tags"
    end
  end
end
