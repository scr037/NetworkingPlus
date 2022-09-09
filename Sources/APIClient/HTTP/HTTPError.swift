import Foundation

public struct HTTPError: Error {
  var statusCode: Int
  var error: Error?

  public init(statusCode: Int, error: Error? = nil) {
    self.statusCode = statusCode
    self.error = error
  }
}
