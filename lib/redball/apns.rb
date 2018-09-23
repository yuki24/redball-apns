# frozen-string-literal: true

require "openssl"
require "base64"

require "redball/apns/version"
require "redball/http2"
require "redball/json"
require "redball/apns/client"
require "redball/apns/exceptions"

module Redball
  module Apns
    ENDPOINTS = {
      development: "https://api.development.push.apple.com:443",
      production:  "https://api.push.apple.com:443"
    }.freeze

    def self.jwt(environment: , cert_path: , team_id: , key_id: , **options)
      cert   = load_certificate(cert_path)
      domain = ENDPOINTS[environment.to_sym] || raise("Unknown environment: #{environment.inspect}")

      Redball::Apns::Client.new(domain, connection: Http2.new, **options)
          .register_interceptor(TokenAuthenticator.new(cert, team_id, key_id))
          .register_interceptor(Redball::JsonSerializer.new)
          .register_observer(Redball::JsonDeserializer.new)
          .register_observer(Redball::Apns::HttpStatusChecker.new)
    end

    def self.load_certificate(cert_path)
      cert_path.respond_to?(:read) ? cert_path.read : File.read(cert_path)
    end

    class JwtGenerator
      attr_reader :cert, :team_id, :key_id

      def initialize(certificate, team_id, key_id)
        @cert    = OpenSSL::PKey::EC.new(certificate)
        @team_id = team_id
        @key_id  = key_id
        @sha256  = OpenSSL::Digest::SHA256.new
      end

      def jwt
        @header ||= Base64.urlsafe_encode64(%Q'{"alg":"ES256","kid":"#{key_id}"}')
        payload   = Base64.urlsafe_encode64(%Q'{"iss":"#{team_id}","iat":#{Time.now.to_i}}')
        signature = Base64.urlsafe_encode64(@cert.dsa_sign_asn1(@sha256.digest("#{@header}.#{payload}")))

        "#{@header}.#{payload}.#{signature}"
      end
    end

    class TokenAuthenticator < JwtGenerator
      def before_request(uri, body, headers, options)
        headers["authorization"] ||= "bearer #{jwt}"

        [uri, body, headers, options]
      end
    end

    private_constant :TokenAuthenticator
  end
end