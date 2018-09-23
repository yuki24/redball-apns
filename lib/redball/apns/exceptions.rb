# frozen-string-literal: true

module Redball
  module Apns
    class APIError < StandardError; end
    class NetworkError < APIError; end

    class HttpError < APIError
      attr_reader :response

      def initialize(message, response)
        super(message)
        @response = response
      end
    end

    class ClientError < HttpError; end

    class BadRequest                  < ClientError; end # status: 400
    class Unauthorized                < ClientError; end # status: 401
    class PaymentRequired             < ClientError; end # status: 402
    class Forbidden                   < ClientError; end # status: 403
    class NotFound                    < ClientError; end # status: 404
    class MethodNotAllowed            < ClientError; end # status: 405
    class NotAcceptable               < ClientError; end # status: 406
    class ProxyAuthenticationRequired < ClientError; end # status: 407
    class RequestTimeout              < ClientError; end # status: 408
    class Conflict                    < ClientError; end # status: 409
    class Gone                        < ClientError; end # status: 410
    class LengthRequired              < ClientError; end # status: 411
    class PreconditionFailed          < ClientError; end # status: 412
    class PayloadTooLarge             < ClientError; end # status: 413
    class URITooLong                  < ClientError; end # status: 414
    class UnsupportedMediaType        < ClientError; end # status: 415
    class RangeNotSatisfiable         < ClientError; end # status: 416
    class ExpectationFailed           < ClientError; end # status: 417
    class ImaTeapot                   < ClientError; end # status: 418
    class MisdirectedRequest          < ClientError; end # status: 421
    class UnprocessableEntity         < ClientError; end # status: 422
    class Locked                      < ClientError; end # status: 423
    class FailedDependency            < ClientError; end # status: 424
    class UpgradeRequired             < ClientError; end # status: 426
    class PreconditionRequired        < ClientError; end # status: 428
    class TooManyRequests             < ClientError; end # status: 429
    class RequestHeaderFieldsTooLarge < ClientError; end # status: 431
    class UnavailableForLegalReasons  < ClientError; end # status: 451

    class ServerError < HttpError; end

    class InternalServerError           < ServerError; end # status: 500
    class NotImplemented                < ServerError; end # status: 501
    class BadGateway                    < ServerError; end # status: 502
    class ServiceUnavailable            < ServerError; end # status: 503
    class GatewayTimeout                < ServerError; end # status: 504
    class HTTPVersionNotSupported       < ServerError; end # status: 505
    class VariantAlsoNegotiates         < ServerError; end # status: 506
    class InsufficientStorage           < ServerError; end # status: 507
    class LoopDetected                  < ServerError; end # status: 508
    class NotExtended                   < ServerError; end # status: 510
    class NetworkAuthenticationRequired < ServerError; end # status: 511

    STATUS_TO_EXCEPTION_MAPPING = {
      400 => BadRequest,
      401 => Unauthorized,
      402 => PaymentRequired,
      403 => Forbidden,
      404 => NotFound,
      405 => MethodNotAllowed,
      406 => NotAcceptable,
      407 => ProxyAuthenticationRequired,
      408 => RequestTimeout,
      409 => Conflict,
      410 => Gone,
      411 => LengthRequired,
      412 => PreconditionFailed,
      413 => PayloadTooLarge,
      414 => URITooLong,
      415 => UnsupportedMediaType,
      416 => RangeNotSatisfiable,
      417 => ExpectationFailed,
      418 => ImaTeapot,
      421 => MisdirectedRequest,
      422 => UnprocessableEntity,
      423 => Locked,
      424 => FailedDependency,
      426 => UpgradeRequired,
      428 => PreconditionRequired,
      429 => TooManyRequests,
      431 => RequestHeaderFieldsTooLarge,
      451 => UnavailableForLegalReasons,
      500 => InternalServerError,
      501 => NotImplemented,
      502 => BadGateway,
      503 => ServiceUnavailable,
      504 => GatewayTimeout,
      505 => HTTPVersionNotSupported,
      506 => VariantAlsoNegotiates,
      507 => InsufficientStorage,
      508 => LoopDetected,
      510 => NotExtended,
      511 => NetworkAuthenticationRequired
    }.freeze

    class HttpStatusChecker
      def received_response(response, _options)
        error = STATUS_TO_EXCEPTION_MAPPING[response.status]
        raise error.new("Received an error response #{response.status} #{error.to_s.split('::').last}: #{response.body}", response) if error
        response
      end
    end
  end
end
