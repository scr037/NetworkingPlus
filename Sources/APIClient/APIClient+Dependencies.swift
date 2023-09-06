//import Dependencies
//
public struct APIClientDependencyKey {
  public static var testValue: APIClient = .failing
  public static var previewValue: APIClient = .mock(
    url: "https://github.com/scr037/NetworkingPlus"
  )
}

//extension DependencyValues {
//  public var apiClient: APIClient {
//    get { self[APIClientDependencyKey.self] }
//    set { self[APIClientDependencyKey.self] = newValue }
//  }
//}
