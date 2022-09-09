import Foundation

extension APIClient {
  public static func live(
    session: URLSession,
    configuration: APIClientConfiguration
  ) -> APIClient {
    APIClient(
      session: session,
      configuration: configuration
    )
  }
}
