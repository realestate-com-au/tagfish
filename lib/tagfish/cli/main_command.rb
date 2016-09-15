require 'tagfish/cli/base_command'
require 'tagfish/cli/tags_command'
require 'tagfish/cli/update_command'
require 'tagfish/version'

module Tagfish
  module CLI

    class MainCommand < BaseCommand

      option ["-v", "--version"], :flag, "display version" do
          puts "tagfish-#{Tagfish::VERSION}"
          exit 0
      end

      subcommand "tags", "find tags for a repository", TagsCommand

      subcommand "update", "inspect files for outdated dependencies", UpdateCommand

      def run(*args)
        super(*args)
      rescue Tagfish::APIError => e
        signal_error e.message
      rescue SocketError => e
        signal_error e.message
      end

    end

  end
end
