require 'tagfish/docker_uri'

module Tagfish
  class SearchCommand < Clamp::Command
    parameter "[KEYWORD]", "object to search"
    option ["-r", "--registry"], "REGISTRY", "Docker registry", :default => "index.docker.io"

    def execute
      if not registry and not keyword
        abort("You need to specify a REGISTRY and/or a KEYWORD")
      end
      
      docker_uri = DockerURI.parse(registry + "/" + "dummy")
      docker_api = DockerRegistryClient.for(docker_uri)
      puts docker_api.search(keyword)
    end
  end
end
