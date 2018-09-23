# frozen-string-literal: true

require "uri"

module Redball
  module Apns
    class Client
      attr_reader :domain, :connection

      def initialize(domain, connection:, **options)
        @domain = domain
        @interceptors = []
        @observers = []
        @connection = connection
        @options = options
      end

      def register_interceptor(interceptor)
        @interceptors << interceptor
        self
      end

      def register_observer(observer)
        @observers << observer
        self
      end

      def push(device_token, body, query: {}, headers: {}, **options)
        request(:post, uri("/3/device/#{device_token}", query), body, headers, method: :push, **options)
      end

      private

      def request(method, uri, body, headers, options = {})
        _uri, _body, _headers, _options = @interceptors.reduce([uri, body, headers, @options.merge(options)]) {|r, i| i.before_request(*r) }

        response = begin
                     connection.send_request(method, _uri, _body, _headers, _options)
                   rescue => e
                     raise NetworkError, "A network error occurred: #{e.class} (#{e.message})"
                   end

        @observers.reduce(response) {|r, o| o.received_response(r, _options) }
      end

      def uri(path, query = {})
        uri = URI.join(domain, path)
        uri.query = URI.encode_www_form(query) unless query.empty?
        uri
      end
    end
  end
end