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
      docker_api = DockerAPI.new(docker_uri)
      
      if docker_api.api_version == 'v2'
        puts search_v2(keyword, docker_api, docker_uri)
      else
        puts search_v1(keyword, docker_api)
      end
    end
    
    def search_v2(keyword, docker_api, docker_uri)
      repos = docker_api.catalog_v2["repositories"]
      if keyword
        repos.select! {|repo| repo.include? keyword}
      end
      repos.map {|repo| "#{docker_uri.registry}/#{repo}"} 
    end
    
    def search_v1(keyword, docker_api)
      if not keyword
        abort("You need to specify a keyword to search a Registry V1")
      end
      repos_raw = docker_api.search_v1(keyword)
      repos = repos_raw["results"].map {|result| result["name"]}
    end
  end
end
