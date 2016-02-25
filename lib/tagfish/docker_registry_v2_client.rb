require 'tagfish/docker_registry_vboth_client'

module Tagfish
  class DockerRegistryV2Client < DockerRegistryVbothClient
    
    def api_version
      'v2'
    end
    
    def find_tags_by_repository(tags_only=false)
      tags_list = tags_v2_logic(tags_only)
      Tagfish::Tags.new(tags_list)
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

    private
    
    def tags_v2_logic(tags_only)
      tags = tags_v2["tags"]
      if tags.nil?
        abort("No Tags found for this repository")
      end
      
      tags_with_hashes = tags.inject({}) do |dict, tag|
        if tags_only
          dict[tag] = "dummy_hash"
        else
          dict[tag] = hash_v2(tag)["fsLayers"][0]["blobSum"]
        end
        dict
      end
    end
      
    def ping_uri
      "#{base_uri}/v2/"
    end

    def catalog_v2_uri
      "#{base_uri}/v2/_catalog"
    end
    
    def tags_v2_uri
      "#{base_uri}/v2/#{docker_uri.repository}/tags/list"  
    end
    
    def hash_v2_uri(tag)
      "#{base_uri}/v2/#{docker_uri.repository}/manifests/#{tag}"
    end
  end
end
