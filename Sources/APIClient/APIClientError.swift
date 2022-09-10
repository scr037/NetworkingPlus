import Foundation

public enum APIClientError: Swift.Error {
  case decodingError(DecodingError)
  case httpError(HTTPError)
  case unhandled(error: Error)
  case invalidResponse
  
  init(_ error: Swift.Error) {
    switch error {
    case let decodingError as DecodingError:
      self = .decodingError(decodingError)
    case let apiError as HTTPError:
      self = .httpError(apiError)
    default:
      self = .unhandled(error: error)
    }
  }
}

/// Error model to decode server side errors.
public struct ErrorResponse: Error, Codable {
  public var code: Int?
  public var message: String
  public var userInfo: [String: String?]?
}
