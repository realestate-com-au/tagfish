require 'tagfish/docker_registry_vboth_client'

module Tagfish
  class DockerRegistryV2Client < DockerRegistryVbothClient
    
    def api_version
      'v2'
    end

  end
end
