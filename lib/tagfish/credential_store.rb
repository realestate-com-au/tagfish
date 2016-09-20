require 'tagfish/registry_credentials'

module Tagfish

  class CredentialStore

    def initialize(docker_config_data)
      @credentials_by_registry = {}
      auths = docker_config_data.fetch("auths", {})
      auths.each do |registry, data|
        registry = registry_address(registry)
        encoded_credentials = data.fetch("auth")
        username, password = Base64.decode64(encoded_credentials).split(":")
        creds = RegistryCredentials.new(username, password)
        @credentials_by_registry[registry] = creds
      end
    end

    def credentials_for(registry)
      registry = registry_address(registry)
      @credentials_by_registry[registry]
    end

    private

    def registry_address(registry)
      registry.sub(%r{^\w+://}, '').sub(%r{/.*}, '')
    end

  end

end
