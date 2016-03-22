require "tagfish/docker_uri"
require "tagfish/docker_registry_client"

module Tagfish
  class TagsCommand < Clamp::Command
    parameter "REPOSITORY", "docker repository"
    option ["-l", "--latest"], :flag, "only return latest explicitly tagged image"
    option ["-s", "--short"], :flag, "only return tag, not full image path"
    option ["-d", "--digest"], :flag, "returns the tag's digest (hash)"

    def execute
      
      docker_uri = DockerURI.parse(repository)
      docker_api = DockerRegistryClient.for(docker_uri)
      
      if latest?
        tags = docker_api.tags
        latest_tags = tags.latest_tags
        if latest_tags.empty?
          signal_error "No image explicitly tagged in this Repository, " +
                  "only `latest` tag available."
        end
        tags_found = latest_tags
        
        if digest?
          tags_found = tags_found.map do |tag_name|
            tag_name + '@' + tags.tag_map[tag_name]
          end
        end
      else
        tags_found = docker_api.tag_names
      end

      tags_fqdn = tags_found.map do |tag_name|
        short? ? tag_name : docker_uri.with_tag(tag_name).to_s
      end
      
      puts tags_fqdn
    end
  end
end
