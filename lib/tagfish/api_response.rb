module Tagfish

  class APIResponse

    def initialize(http_response)
      @http_response = http_response
    end

    attr_reader :http_response

    def json
      JSON.parse(http_response.body)
    end

    def code
      Integer(http_response.code)
    end

    def digest
      http_response.fetch("Docker-Content-Digest")
    end

  end

end
