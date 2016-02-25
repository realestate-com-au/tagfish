require 'tagfish/docker_registry_vboth_client'

module Tagfish
  class DockerRegistryV1Client < DockerRegistryVbothClient
    
    def api_version
      'v1'
    end
    
  end
end
