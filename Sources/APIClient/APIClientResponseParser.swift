import Foundation

public struct APIClientResponseHandler<Output, Error> {
  public var handleSuccess: (Data) throws -> Output
  public var handleFailure: (Data) throws -> Error
}

extension APIClientResponseHandler where Output: Decodable, Error: Decodable {
  public static func shared(decoder: JSONDecoder) -> APIClientResponseHandler<Output, Error> {
    APIClientResponseHandler(
      handleSuccess: { try decoder.decode(Output.self, from: $0) },
      handleFailure: { try decoder.decode(Error.self, from: $0) }
    )
  }
}

extension APIClientResponseHandler where Output == Void, Error: Decodable {
  public static func shared(decoder: JSONDecoder) -> APIClientResponseHandler<Output, Error> {
    APIClientResponseHandler(
      handleSuccess: { _ in () },
      handleFailure: { try decoder.decode(Error.self, from: $0) }
    )
  }
}
