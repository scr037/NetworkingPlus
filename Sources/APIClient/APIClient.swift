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

// MARK: iOS 12 Compatibility

extension APIClient {
  public func responseWithCompletion<Output, Error>(
    request: APIClientRequest,
    responseHandler: APIClientResponseHandler<Output, Error>,
    completion: @escaping (Result<Output, APIClientError> ) -> Void
  ) where Error: Swift.Error {
    let request = request.requestFrom(configuration: configuration)
    session.dataTask(with: request) { data, response, error in
      let httpResponse = response as! HTTPURLResponse
      
      guard let data = data else { return }
      guard 200 ..< 300 ~= httpResponse.statusCode else {
        do {
          let error = data.isEmpty ? nil : try responseHandler.handleFailure(data)
          let httpError = HTTPError(statusCode: httpResponse.statusCode, error: error)
          completion(.failure(.httpError(httpError)))
        } catch {
          completion(.failure(.invalidResponse))
        }
        return
      }

      do {
        let output = try responseHandler.handleSuccess(data)
        completion(.success(output))
      } catch {
        completion(.failure(.invalidResponse))
      }
    }
    .resume()
  }
}

// MARK: Custom

extension APIClient {
  public func responseHeaders(request: APIClientRequest) async throws -> [AnyHashable: Any]? {
    let request = request.requestFrom(configuration: configuration)
    let result = try await session.data(for:request)
    guard let httpResponse = result.1 as? HTTPURLResponse else { return nil }
    return httpResponse.allHeaderFields
  }
}
