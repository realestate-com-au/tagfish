module Tagfish
  class Tokeniser

    class Text < String
      def is_a_uri_token?
        false
      end
    end

    class URI < String
      def is_a_uri_token?
        true
      end
    end

    def self.tokenise(rest)
      tokens = []
      while true
        match = rest.match /[\w\/:.-]+\/[\w.-]+:[\w.-]+/
        if match.nil?
          tokens << Text.new(rest)
          break
        else
          tokens << Text.new(match.pre_match)
          tokens << URI.new(match.to_s)
          rest = match.post_match
        end
      end

      tokens
    end

    def self.dump(tokens)
      tokens.join('')
    end
  end
end
