module Tagfish
  module Update
    class URIFilters
      def self.must_be_tagged
        lambda do |uri| uri.tag? end
      end

      def self.must_not_be_tagged_latest
        lambda do |uri| not uri.tagged_latest? end
      end

      def self.must_match_repository(pattern)
        starts_with_pattern = "#{pattern}*"
        lambda do |uri| 
          File.fnmatch(starts_with_pattern, uri.with_tag(nil).to_s)
        end
      end
    end
  end
end
