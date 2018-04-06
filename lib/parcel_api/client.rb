require 'oauth2'

require 'active_support'
require 'active_support/core_ext/numeric/time'

module ParcelApi
  class Client

    attr_accessor :client_id,
      :client_secret,
      :username,
      :password,
      :address,
      :auth_address

    def self.connection
      @connection ||= new.connection
    end

    def initialize
      @client_id     = client_id     || ENV['CLIENT_ID']
      @client_secret = client_secret || ENV['CLIENT_SECRET']
      @username      = username      || ENV['USERNAME']
      @password      = password      || ENV['PASSWORD']
      @address       = address       || 'https://api.nzpost.co.nz'
      @auth_address  = auth_address  || 'https://oauth.nzpost.co.nz/as/token.oauth2'
    end

    def connection
      client.password.get_token @username, @password
    end

    private

    def client
      OAuth2::Client.new(@client_id, @client_secret, site: @address, token_url: @auth_address, connection_opts: { headers: { 'client_id' => @client_id } })
    end

  end
end
