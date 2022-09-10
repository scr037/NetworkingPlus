import Foundation

extension APIClientConfiguration {
  public static func mock(urlString: String) -> APIClientConfiguration {
    APIClientConfiguration(
      baseURL: { URL(string: urlString)! },
      httpHeaders: { [] },
      queryItems: { [] }
    )
  }
}

extension APIClient {
  public static func mock(url: String) -> APIClient {
    APIClient(
      session: .init(configuration: .ephemeral),
      configuration: .mock(urlString: url)
    )
  }

  public static var failing: APIClient {
    APIClient(
      session: .init(configuration: .ephemeral),
      // This will fail because the URL will be empty. However:
      // FIXME: Replace by failing or unimplemented implementation.
      configuration: .mock(urlString: "")
    )
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
