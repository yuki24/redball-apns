# frozen-string-literal: true

require 'json'
require 'delegate'

module Redball
  class JsonSerializer
    APPLICATION_JSON = 'application/json'.freeze
    JSON_REQUEST_HEADERS = {
      'Content-Type' => APPLICATION_JSON,
      'Accept' => APPLICATION_JSON
    }.freeze

    def before_request(uri, body, headers, options)
      headers = headers.merge(JSON_REQUEST_HEADERS)
      body = body.nil? || body.is_a?(String) ? body : body.to_json

      [uri, body, headers, options]
    end
  end

  class JsonDeserializer
    def received_response(response, _options)
      JsonResponse.new(response)
    end

    class JsonResponse < SimpleDelegator
      alias response __getobj__
      HAS_SYMBOL_GC = RUBY_VERSION > '2.2.0'

      def json
        parseable? ? JSON.parse(body, symbolize_names: HAS_SYMBOL_GC) : nil
      end

      def inspect
        "#<JsonResponse response: #{response.inspect}, json: #{json}>"
      end

      alias to_s inspect

      def parseable?
        !!body && !body.empty?
      end
    end

    private_constant :JsonResponse
  end
end
