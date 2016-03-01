require 'tagfish/docker_registry_v1_client'
require 'tagfish/docker_registry_v2_client'

module Tagfish
  module DockerRegistryClient

    def self.for(*args)
      [DockerRegistryV2Client, DockerRegistryV1Client].each do |client_class|
        begin 
          return client_class.new(*args)
        rescue APIVersionError
        end
      end
      raise APIVersionError, "API version unrecognized!"
    end
    
    class AuthenticationError < StandardError
    end
    
    class APIVersionError < StandardError
    end
    
  end
end
