import Dependencies

public struct APIClientDependencyKey: TestDependencyKey {
  public static var testValue: APIClient = .failing
  public static var previewValue: APIClient = .failing
}

extension DependencyValues {
  public var apiClient: APIClient {
    get { self[APIClientDependencyKey.self] }
    set { self[APIClientDependencyKey.self] = newValue }
  }
}
