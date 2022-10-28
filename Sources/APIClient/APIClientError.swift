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

// Equatable conformance
extension APIClientError: Equatable {
  public static func == (lhs: APIClientError, rhs: APIClientError) -> Bool {
    switch (lhs, rhs) {
    case (.decodingError(let lhError), .decodingError(let rhError)):
      return lhError.errorDescription == rhError.errorDescription
    case (.httpError(let lhError), .httpError(let rhError)):
      return lhError.localizedDescription == rhError.localizedDescription
    case (.unhandled(let lhError), .unhandled(let rhError)):
      return lhError.localizedDescription == rhError.localizedDescription
    case (.invalidResponse, .invalidResponse):
      return true
    default:
      return false
    }
  }
}

/// Error model to decode server side errors.
public struct ErrorResponse: Error, Codable {
  public var code: Int?
  public var message: String
  public var userInfo: [String: String?]?
}
