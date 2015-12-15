require 'net/http'
require 'json'

module Tagfish
  class Tags

    def initialize(tags)
      @tags = tags
    end

    def tag_names
      @tags.keys.sort
    end

    def latest_tag
      tag_names.select do |tag_name|
        (@tags[tag_name] == @tags["latest"]) && (tag_name != 'latest')
      end
    end

    def latest_tag_to_s
      latest_tag.empty? ? nil : latest_tag[0]
    end

  end
end
