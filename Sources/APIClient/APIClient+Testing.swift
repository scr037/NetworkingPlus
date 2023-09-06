import Foundation

extension APIClientConfiguration {
  public static func mock(urlString: String) -> APIClientConfiguration {
    #if DEBUG
    APIClientConfiguration(
      baseURL: { URL(string: urlString)! },
      httpHeaders: { [] },
      queryItems: { [] }
    )
    #else
    fatalError("Shouldn't be available in this context.")
    #endif
  }
}

extension APIClient {
  public static func mock(url: String) -> APIClient {
    #if DEBUG
    APIClient(
      session: .init(configuration: .ephemeral),
      configuration: .mock(urlString: url)
    )
    #else
    fatalError("Shouldn't be available in this context.")
    #endif
  }

  public static var failing: APIClient {
    #if DEBUG
    APIClient(
      session: .init(configuration: .ephemeral),
      // This will fail because the URL will be empty. However:
      // FIXME: Replace by failing or unimplemented implementation.
      configuration: .mock(urlString: "")
    )
    #else
    fatalError("Shouldn't be available in this context.")
    #endif
  }

  public static func stub(
    configuration: APIClientConfiguration,
    request: APIClientRequest,
    statusCode: Int,
    data: Data?
  ) -> APIClient {
    HTTPStubProtocol.stub(
      configuration: configuration,
      request: request,
      statusCode: statusCode,
      data: data
    )
    let sessionConfiguration: URLSessionConfiguration = .ephemeral
    sessionConfiguration.protocolClasses = [HTTPStubProtocol.self]
    return APIClient(
      session: URLSession(configuration: sessionConfiguration),
      configuration: configuration
    )
  }
}
