import Foundation

extension APIClientConfiguration {
  static func mock(urlString: String) -> APIClientConfiguration {
    APIClientConfiguration(
      baseURL: { URL(string: urlString)! },
      httpHeaders: { [] },
      queryItems: { [] }
    )
  }
}

extension APIClient {
  public static var failing: APIClient {
    APIClient(
      session: .init(configuration: .ephemeral),
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
