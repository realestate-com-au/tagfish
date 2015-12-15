require "tagfish/tags_logic"
require "tagfish/docker_uri"

module Tagfish
  class TagsCommand < Clamp::Command
    parameter "REPOSITORY", "docker repository"
    option ["-l", "--latest"], :flag, "only return latest explicitly tagged image"
    option ["-s", "--short"], :flag, "only return tag, not full image path"

    def execute
      tags_only = latest? ? false : true
      
      docker_uri = DockerURI.parse(repository)
      docker_api = DockerAPI.new(docker_uri)
      tags = TagsLogic.find_tags_by_repository(docker_api, tags_only)

      begin
       tags_found = latest? ? tags.latest_tag : tags.tag_names
      rescue Exception => e
        puts e.message
        return
      end

      if tags_found.size == 0
        puts "ERROR: No image explicitly tagged in this Repository, " +
                "only `latest` tag available."
        return
      end

      pretty_tags = tags_found.map do |tag_name|
        short? ? tag_name : docker_uri.with_tag(tag_name).to_s
      end

      puts pretty_tags
    end
  end
end
