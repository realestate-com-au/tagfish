require 'json'
require 'base64'

module Tagfish

  module DockerHttpAuth

    Credentials = Struct.new(:username, :password)

    def self.for_registry(registry)
       file_path = '~/.docker/config.json'

       begin
         config = File.open(File.expand_path(file_path), 'r')
       rescue Exception => e
         abort("Tried to get username/password but the file #{file_path} does not exist")
       end

       json_config = JSON.parse(config.read())
       config.close()
       if json_config['auths'].length == 0
         Credentials.new(nil, nil)
       else
         b64_auth = json_config['auths'][registry]['auth']
         auth = Base64.decode64(b64_auth)
         Credentials.new(*auth.split(':'))
       end
    end

  end
end
