require 'tagfish/update/updater'
require 'tagfish/update/differ'
require 'tagfish/update/uri_filters'
require 'tagfish/tokeniser'

module Tagfish
  module Update
    class UpdateCommand < Clamp::Command
      parameter "[FILE]", "file to update", :default => "Dockerfile"
      option ["-d", "--dry-run"], :flag, "enable dry run"
      option "--only", "PATTERN", "Only update repositories matching pattern. Wildcards (*) may be used."

      def execute
        filters = [
          URIFilters.must_be_tagged,
          URIFilters.must_not_be_tagged_latest,
          URIFilters.must_match_repository(only)
        ]
        updater = Updater.new(filters)
        original = File.read(file)
        updated = Tokeniser.dump(updater.update(Tokeniser.tokenise(original)))

        puts Differ.diff(original, updated)
        
        if not dry_run? 
          File.write(file, updated)
        end
      end
    end
  end
end
