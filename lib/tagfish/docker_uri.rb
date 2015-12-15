require 'tagfish/docker_http_auth'
require 'tagfish/docker_api'

module Tagfish
  class DockerURI
    URI_PARSER = %r{
      (https?:\/\/)?                # Optional protocol
      (?:([\w.\-]+\.[\w.\-]+)\/)?   # Optional registry
      ([\w\-]*\/?[\w\-.]+)          # Optional namespace, mandatory repository
      :?                            # Optional delimiter between repository and tag
      ([\w.\-]+)?                   # Optional tag
    }x

    def self.parse(docker_string)
      match = docker_string.match(URI_PARSER)
      new(*match.captures)
    end

    attr_accessor :protocol
    attr_accessor :registry
    attr_accessor :repository
    attr_accessor :tag

    def initialize(protocol, registry, repository, tag)
      @protocol = protocol
      @registry = registry
      @repository = repository
      @tag = tag

      if registry.nil?
        @protocol = "https://"
        @registry = "index.docker.io"
      elsif protocol.nil?
        @protocol = "https://"
      end
    end
    
    def repo_and_tag
      tag.nil? ? "#{repository}" : "#{repository}:#{tag}"
    end

    def tag?
      not tag.nil?
    end

    def tagged_latest?
      tag == 'latest'
    end

    def with_tag(new_tag)
      self.class.new(protocol, registry, repository, new_tag)
    end

    def to_s
      reg_sep = registry.nil? ? nil : "/"
      tag_sep = tag.nil? ? nil : ":"
      if registry == "index.docker.io"
        "#{repository}#{tag_sep}#{tag}"
      else
        "#{registry}#{reg_sep}#{repository}#{tag_sep}#{tag}"
      end
    end
  end
end
