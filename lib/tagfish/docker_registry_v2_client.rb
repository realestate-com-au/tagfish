require 'tagfish/docker_registry_vboth_client'

module Tagfish
  class DockerRegistryV2Client < DockerRegistryVbothClient
    
    def api_version
      'v2'
    end
    
    def catalog
      APICall.new(catalog_uri).get_json(http_auth)
    end
    
    def tag_names
      tags["tags"]
    end

    def tag_map
      Tagfish::Tags.new(tags_logic)
    end

    private
    
    def tags
      APICall.new(tags_uri).get_json(http_auth)
    end
    
    def hash(tag)
      APICall.new(hash_uri(tag)).get_json(http_auth)
    end
    
    def tags_logic
      if tag_names.nil?
        abort("No Tags found for this repository")
      end
      
      tags_with_hashes = tag_names.inject({}) do |dict, tag|
        dict[tag] = hash(tag)["fsLayers"][0]["blobSum"]
        dict
      end
    end
      
    def ping_uri
      "#{base_uri}/v2/"
    end

    def catalog_uri
      "#{base_uri}/v2/_catalog"
    end
    
    def tags_uri
      "#{base_uri}/v2/#{docker_uri.repository}/tags/list"  
    end
    
    def hash_uri(tag)
      "#{base_uri}/v2/#{docker_uri.repository}/manifests/#{tag}"
    end
  end
end
