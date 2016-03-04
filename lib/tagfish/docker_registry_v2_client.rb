require 'tagfish/docker_registry_vboth_client'

module Tagfish
  class DockerRegistryV2Client < DockerRegistryVbothClient
    
    def api_version
      'v2'
    end
    
    def tag_names
      tags["tags"]
    end

    def tag_map
      Tagfish::Tags.new(tags_logic)
    end

    private
    
    def tags
      api_call.get(tags_uri).json
    end
    
    def hash(tag)
      api_call.get(hash_uri(tag)).json
    end
    
    def tags_logic
      if tag_names.nil?
        abort("No Tags found for this repository")
      end
      
      tags_with_hashes = tag_names.inject({}) do |dict, tag|
        dict[tag] = hash(tag)["fsLayers"]
        dict
      end
    end
      
    def ping_uri
      "#{base_uri}/v2/"
    end

    def tags_uri
      "#{base_uri}/v2/#{docker_uri.repository}/tags/list"  
    end
    
    def hash_uri(tag)
      "#{base_uri}/v2/#{docker_uri.repository}/manifests/#{tag}"
    end
  end
end
