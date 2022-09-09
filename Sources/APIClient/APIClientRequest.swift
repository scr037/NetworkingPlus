import Foundation

public struct APIClientRequest {
  private var resourcePath: String
  private var httpMethod: HTTPMethod
  private var queryParameters: Set<URLQueryItem>
  private var httpHeaders: Set<HTTPHeader>
  private var httpBody: Data?

  internal init(
    resourcePath: String,
    httpMethod: HTTPMethod,
    queryParameters: Set<URLQueryItem>,
    httpHeaders: Set<HTTPHeader>,
    body: Data? = nil
  ) {
    self.resourcePath = resourcePath
    self.httpMethod = httpMethod
    self.queryParameters = queryParameters
    self.httpHeaders = httpHeaders
    self.httpBody = body
  }
}

// MARK: Convenience

extension APIClientRequest {

  public func requestFrom(configuration: APIClientConfiguration) -> URLRequest {
    let url = configuration.baseURL().appendingPathComponent(self.resourcePath)

    guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
    else { fatalError("\(Self.self) cannot resolve url: \(url.absoluteString)") }

    let queryItems = configuration.queryItems().union(self.queryParameters)
    components.queryItems = Array(queryItems)

    var request = URLRequest(url: components.url!)
    request.httpMethod = self.httpMethod.rawValue
    request.httpBody = self.httpBody

    configuration.httpHeaders().forEach { header in
      request.addValue(header.value, forHTTPHeaderField: header.key)
    }
    self.httpHeaders.forEach { header in
      request.addValue(header.value, forHTTPHeaderField: header.key)
    }

    return request
  }
}


// MARK: Instances

extension APIClientRequest {

  static func get(
    _ resourcePath: String,
    queryParams: Set<URLQueryItem> = [],
    httpHeaders: Set<HTTPHeader> = []
  ) -> APIClientRequest {
    APIClientRequest(
      resourcePath: resourcePath,
      httpMethod: .get,
      queryParameters: queryParams,
      httpHeaders: httpHeaders,
      body: nil
    )
  }

  static func post(
    _ resourcePath: String,
    queryParams: Set<URLQueryItem> = [],
    httpHeaders: Set<HTTPHeader> = []
  ) -> APIClientRequest {
    APIClientRequest(
      resourcePath: resourcePath,
      httpMethod: .post,
      queryParameters: queryParams,
      httpHeaders: httpHeaders,
      body: nil
    )
  }

  static func post<Body>(
    _ resourcePath: String,
    queryParams: Set<URLQueryItem> = [],
    httpHeaders: Set<HTTPHeader> = [],
    body: Body,
    encoder: JSONEncoder
  ) throws -> APIClientRequest where Body: Encodable {
    APIClientRequest(
      resourcePath: resourcePath,
      httpMethod: .post,
      queryParameters: queryParams,
      httpHeaders: httpHeaders,
      body: try encoder.encode(body)
    )
  }

  static func put(
    _ resourcePath: String,
    queryParams: Set<URLQueryItem> = [],
    httpHeaders: Set<HTTPHeader> = []
  ) -> APIClientRequest {
    APIClientRequest(
      resourcePath: resourcePath,
      httpMethod: .put,
      queryParameters: queryParams,
      httpHeaders: httpHeaders,
      body: nil
    )
  }
  
  static func put<Body>(
    _ resourcePath: String,
    queryParams: Set<URLQueryItem> = [],
    httpHeaders: Set<HTTPHeader> = [],
    body: Body,
    encoder: JSONEncoder
  ) throws -> APIClientRequest where Body: Encodable {
    APIClientRequest(
      resourcePath: resourcePath,
      httpMethod: .put,
      queryParameters: queryParams,
      httpHeaders: httpHeaders,
      body: try encoder.encode(body)
    )
  }

  static func delete(
    _ resourcePath: String,
    queryParams: Set<URLQueryItem> = [],
    httpHeaders: Set<HTTPHeader> = []
  ) -> APIClientRequest {
    APIClientRequest(
      resourcePath: resourcePath,
      httpMethod: .post,
      queryParameters: queryParams,
      httpHeaders: httpHeaders,
      body: nil
    )
  }

  static func head(
    _ resourcePath: String,
    httpHeaders: Set<HTTPHeader> = []
  ) -> APIClientRequest {
    APIClientRequest(
      resourcePath: resourcePath,
      httpMethod: .head,
      queryParameters: [],
      httpHeaders: httpHeaders,
      body: nil
    )
  }
}
