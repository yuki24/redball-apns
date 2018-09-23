# frozen-string-literal: true

require "curb"

module Redball
  class Http2
    BY_HEADER_LINE   = /[\r\n]+/.freeze
    HEADER_VALUE     = /^(\S+): (.+)/.freeze

    DEFAULT_CLIENT_OPTIONS = {
      connect_timeout: 30,
      timeout: 5
    }.freeze

    attr_reader :multi

    def initialize(max_connects: 100, **options)
      @multi        = Curl::Multi.new
      @easy_options = DEFAULT_CLIENT_OPTIONS.merge(options).freeze

      @multi.pipeline     = Curl::CURLPIPE_MULTIPLEX
      @multi.max_connects = max_connects
    end

    def send_request(method, uri, body, headers, *_)
      easy = Curl::Easy.new(uri.to_s)

      # This ensures libcurl waits for the connection to reveal if it is
      # possible to pipeline/multiplex on before it continues.
      easy.setopt(Curl::CURLOPT_PIPEWAIT, 1)

      easy.multi       = @multi
      easy.version     = Curl::HTTP_2_0
      easy.headers     = headers || {}
      easy.post_body   = body if method == :post || method == :put || method == :patch

      easy.public_send(:"http_#{method}")

      Response.new(
        Hash[easy.header_str.split(BY_HEADER_LINE).flat_map {|s| s.scan(HEADER_VALUE) }].freeze,
        easy.body.freeze,
        easy.response_code,
        easy,
      ).freeze
    end

    Response = Struct.new(:headers, :body, :code, :raw_response) do
      alias to_hash headers
      alias status  code
    end

    private_constant :BY_HEADER_LINE, :HEADER_VALUE, :Response
  end
end