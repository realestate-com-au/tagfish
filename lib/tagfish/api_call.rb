module Tagfish
  class APICall
    attr_accessor :uri
    attr_accessor :http
    attr_accessor :request
  
    def initialize(uri_string) 
      @uri = URI.parse(uri_string)
      @http = Net::HTTP.new(uri.host, uri.port)
      @http.use_ssl = true if uri.port == 443
      @request = Net::HTTP::Get.new(uri.request_uri)
    end
        
    def get_json(http_auth=nil)
      begin
        auth(http_auth) if http_auth
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

    def response_code(http_auth=nil)
      auth(http_auth) if http_auth
      begin
        http.request(request).code.to_i
      rescue SocketError
        abort("Call to the registry API failed, the following resource might not exist:\n#{uri.to_s}")
      end
    end

    def auth(http_auth)
      @request.basic_auth(http_auth.username, http_auth.password)
    end
  end
end