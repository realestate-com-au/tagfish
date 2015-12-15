require 'diffy'

module Tagfish
  module Update
    class Differ
      def self.diff(original_string, updated_string)
        diffy_diff = Diffy::Diff.new(original_string, updated_string, context: 2)
        colour_diff = diffy_diff.to_s(:color).chomp
        colour_diff.empty? ? "Nothing to update here" : colour_diff
      end
    end
  end
end
