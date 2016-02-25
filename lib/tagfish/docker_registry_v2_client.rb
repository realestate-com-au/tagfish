require 'tagfish/docker_registry_vboth_client'

module Tagfish
  class DockerRegistryV2Client < DockerRegistryVbothClient
    
    def api_version
      'v2'
    end
    
    def catalog
      APICall.new(catalog_uri).get_json(http_auth)
    end

    private
    
    def tags
      APICall.new(tags_uri).get_json(http_auth)
    end
    
    def hash(tag)
      APICall.new(hash_uri(tag)).get_json(http_auth)
    end
    
    def find_tags_by_repository(tags_only=false)
      tags_list = tags_logic(tags_only)
      Tagfish::Tags.new(tags_list)
    end
    
    def tags_logic(tags_only)
      tag_names = tags["tags"]
      if tag_names.nil?
        abort("No Tags found for this repository")
      end
      
      tags_with_hashes = tag_names.inject({}) do |dict, tag|
        if tags_only
          dict[tag] = "dummy_hash"
        else
          dict[tag] = hash(tag)["fsLayers"][0]["blobSum"]
        end
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
