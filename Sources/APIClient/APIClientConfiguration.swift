import Foundation

public struct APIClientConfiguration {
  public var baseURL: () -> URL
  public var httpHeaders: () -> Set<HTTPHeader>
  public var queryItems: () -> Set<URLQueryItem>
}

extension APIClientConfiguration {
  public func `default`(
    baseURL: URL,
    httpHeaders: Set<HTTPHeader>,
    queryItems: Set<URLQueryItem>
  ) -> Self {
    APIClientConfiguration(
      baseURL: { baseURL },
      httpHeaders: { httpHeaders },
      queryItems: { queryItems }
    )
  }
}
