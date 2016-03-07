require 'net/http'
require 'json'

module Tagfish
  class Tags

    attr_reader :tag_map 
    
    def initialize(tag_map)
      @tag_map = tag_map
    end

    def tag_names
      tag_map.keys.sort
    end

    def latest_tags
      tag_names.select do |tag_name|
        (tag_map[tag_name] == tag_map["latest"]) && (tag_name != "latest")
      end
    end

  end
end
