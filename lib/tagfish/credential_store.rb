require 'tagfish/registry_credentials'

module Tagfish

  class CredentialStore

    def initialize(docker_config_data)
      @credentials_by_registry = {}
      auths = docker_config_data.fetch("auths", {})
      auths.each do |registry, data|
        encoded_credentials = data.fetch("auth")
        username, password = Base64.decode64(encoded_credentials).split(":")
        creds = RegistryCredentials.new(username, password)
        @credentials_by_registry[registry] = creds
      end
    end

    def credentials_for(registry)
      @credentials_by_registry[registry]
    end

  end

end
