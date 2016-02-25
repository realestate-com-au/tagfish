require "tagfish/docker_uri"
require "tagfish/docker_registry_client"

module Tagfish
  class TagsCommand < Clamp::Command
    parameter "REPOSITORY", "docker repository"
    option ["-l", "--latest"], :flag, "only return latest explicitly tagged image"
    option ["-s", "--short"], :flag, "only return tag, not full image path"

    def execute
      
      docker_uri = DockerURI.parse(repository)
      docker_api = DockerRegistryClient.for(docker_uri)
      
      if latest?
        tags = docker_api.find_tags_by_repository(false)
        latest_tag = tags.latest_tag
        if latest_tag.nil?
          signal_error "No image explicitly tagged in this Repository, " +
                  "only `latest` tag available."
        end
        tags_found = [latest_tag]
      else
        tags = docker_api.find_tags_by_repository(true)
        tags_found = tags.tag_names
      end

      pretty_tags = tags_found.map do |tag_name|
        short? ? tag_name : docker_uri.with_tag(tag_name).to_s
      end

      puts pretty_tags
    end
  end
end
