import Combine
import Foundation

public struct APIClient {
  let session: URLSession
  let configuration: APIClientConfiguration
}

// MARK: Async await

extension APIClient {
  public func response<Output, Error>(
    request: APIClientRequest,
    responseHandler: APIClientResponseHandler<Output, Error>
  ) async throws -> Result<Output, APIClientError> where Error: Swift.Error {
    let request = request.requestFrom(configuration: configuration)
    let result = try await session.data(for:request)
    let data = result.0
    let httpResponse = result.1 as! HTTPURLResponse

    guard 200 ..< 300 ~= httpResponse.statusCode else {
      let error = data.isEmpty ? nil : try responseHandler.handleFailure(data)
      let httpError = HTTPError(statusCode: httpResponse.statusCode, error: error)
      return .failure(.httpError(httpError))
    }
    let output = try responseHandler.handleSuccess(data)
    return .success(output)
  }
}
