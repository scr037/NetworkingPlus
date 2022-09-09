import Foundation

public final class HTTPStubProtocol: URLProtocol {
  struct HTTPStubResponse {
    var data: Data?
    var response: HTTPURLResponse
  }

  static var stubResponse: HTTPStubResponse!

  override public class func canInit(with request: URLRequest) -> Bool {
    true
  }
  
  override public class func canonicalRequest(for request: URLRequest) -> URLRequest {
    request
  }
  
  override public class func requestIsCacheEquivalent(_: URLRequest, to _: URLRequest) -> Bool {
    false
  }

  override public func startLoading() {
    client!.urlProtocol(self, didReceive: Self.stubResponse.response, cacheStoragePolicy: .notAllowed)
    if let data = Self.stubResponse.data {
      client!.urlProtocol(self, didLoad: data)
    }
    client!.urlProtocolDidFinishLoading(self)
  }

  override public func stopLoading() {}
}

extension HTTPStubProtocol {

  static public func stub(
    configuration: APIClientConfiguration,
    request: APIClientRequest,
    statusCode: Int,
    data: Data?
  ) {
    let request = request.requestFrom(configuration: configuration)
    stubResponse = .init(
      data: data,
      response: .init(
        url: request.url!,
        statusCode: statusCode,
        httpVersion: "HTTP/2.2",
        headerFields: request.allHTTPHeaderFields
      )!
    )
  }
}
