require 'tagfish/docker_registry_vboth_client'

module Tagfish
  module DockerRegistryClient

    def self.for(*args)
      DockerRegistryVbothClient.new(*args)
    end
    
  end
end
