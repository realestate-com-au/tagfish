require 'tagfish/docker_http_auth'

module Tagfish
  class APICall
    attr_accessor :uri
    attr_accessor :http
    attr_accessor :request
    attr_accessor :http_auth
    attr_accessor :debug
    
    def initialize (debug = false)
      @debug = debug
      @auth = nil
    end
    
    def get(uri_string)
      @uri = URI.parse(uri_string)
      @http = Net::HTTP.new(uri.host, uri.port)
      @http.use_ssl = true if uri.port == 443
      @http.set_debug_output($stderr) if debug
      @request = Net::HTTP::Get.new(uri.request_uri)
      if http_auth
        @request.basic_auth(http_auth.username, http_auth.password)
      end
      self
    end
    
    def auth(registry)
      @http_auth = DockerHttpAuth.new(registry)
    end
    
    def json
      begin
        response = http.request(request)
        if response.code == "200"
          return JSON.parse(response.body)
        else
          abort("Call to the registry API failed, the following resource might not exist:\n#{uri.to_s}")
        end
      rescue SocketError
        puts "ERROR: SocketError"
      end
    end

    def response_code
      begin
        http.request(request).code.to_i
      rescue SocketError
        abort("Call to the registry API failed, the following resource might not exist:\n#{uri.to_s}")
      end
    end
    
    def digest
      begin
        response = http.request(request)
        return response.fetch("Docker-Content-Digest")
      rescue SocketError
        puts "ERROR: SocketError"
      end
    end
  end
end
