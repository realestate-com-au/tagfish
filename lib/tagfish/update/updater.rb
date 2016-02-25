require 'tagfish/tokeniser'
require 'tagfish/docker_uri'
require 'tagfish/docker_registry_client'

module Tagfish
  module Update
    class Updater
      def initialize(filters)
        @filters = filters
      end

      def update(tokens)
        tokens.map do |token|
          if token.is_a_uri_token?
            update_uri_token(token)
          else
            token
          end
        end
      end

      private

      def update_uri_token(token)
        original_uri = DockerURI.parse(token)
        if updatable?(original_uri)
          updated_uri = update_uri(original_uri)
          Tokeniser::URI.new(updated_uri.to_s)
        else
          token
        end
      end

      def updatable?(uri)
        @filters.all? do |filter|
          filter.call uri
        end
      end

      def update_uri(docker_uri)
        docker_api = DockerRegistryClient.new(docker_uri)
        tags = docker_api.find_tags_by_repository
        newest_tag_name = tags.latest_tag_to_s
        if newest_tag_name.nil?
          docker_uri
        else
          docker_uri.with_tag(newest_tag_name)
        end
      end

    end
  end
end
