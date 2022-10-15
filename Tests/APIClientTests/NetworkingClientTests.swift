import XCTest

@testable import APIClient

final class NetworkingClientTests: XCTestCase {
  func testEmptyResponse() async throws {
    let apiClient: APIClient = .stub(
      configuration: .init(
        baseURL: { URL(string: "https://awoiaf.westeros.org")! },
        httpHeaders: { [] },
        queryItems: { [] }
      ),
      request: .get("/some/resource/path/"),
      statusCode: 200,
      data: nil
    )

    let result = try await apiClient.response(
      request: .get("/some/resource/path/"),
      responseHandler: APIClientResponseHandler<Void, ErrorResponse>.shared(decoder: JSONDecoder())
    )

    switch result {
    case .success(let output):
      XCTAssertNotNil(output)
    case .failure:
      XCTFail("\(Self.self) shouldn't have received a failing result.")
    }
  }

  func testResponseHeaders() async throws {
    let apiClient: APIClient = .stub(
      configuration: .init(
        baseURL: { URL(string: "https://awoiaf.westeros.org")! },
        httpHeaders: { [
          .init(key: "any_header", value: "any_value")
        ] },
        queryItems: { [] }
      ),
      request: .get("/some/resource/path/"),
      statusCode: 200,
      data: nil
    )

    let result = try await apiClient.responseHeaders(request: .get("/some/resource/path/"))
    XCTAssertEqual(result as! [String: String], ["any_header": "any_value"])
  }
  
  func testResponseWithString() async throws {
    let value = "RESPONSE"
    let apiClient: APIClient = .stub(
      configuration: .init(
        baseURL: { URL(string: "https://awoiaf.westeros.org")! },
        httpHeaders: { [] },
        queryItems: { [] }
      ),
      request: .get("/some/resource/path/"),
      statusCode: 200,
      data: try JSONEncoder().encode(value)
    )

    let result = try await apiClient.response(
      request: .get("/some/resource/path/"),
      responseHandler: APIClientResponseHandler<String, ErrorResponse>.shared(decoder: JSONDecoder())
    )

    switch result {
    case .success(let output):
      XCTAssertEqual(output, value)
    case .failure:
      XCTFail("\(Self.self) shouldn't have received a failing result.")
    }
  }

  func testResponseWithObject() async throws {
    struct Mock: Codable, Equatable {
      let id: String
      let name: String
      let index: Int
      let metadata: [String: String]
    }
    let value = Mock(id: "1", name: "First Mock", index: 0, metadata: ["Use": "Testing"])
    let apiClient: APIClient = .stub(
      configuration: .init(
        baseURL: { URL(string: "https://awoiaf.westeros.org")! },
        httpHeaders: { [] },
        queryItems: { [] }
      ),
      request: .get("/some/resource/path"),
      statusCode: 200,
      data: try JSONEncoder().encode(value)
    )

    let result = try await apiClient.response(
      request: .get("/some/resource/path/"),
      responseHandler: APIClientResponseHandler<Mock, ErrorResponse>.shared(decoder: JSONDecoder())
    )

    switch result {
    case .success(let output):
      XCTAssertEqual(output, value)
    case .failure:
      XCTFail("\(Self.self) shouldn't have received a failing result.")
    }
  }

  func testErrorResponse() async throws {
    let someError = ErrorResponse(code: 400, message: "Bad request")
    let data = try JSONEncoder().encode(someError)
    
    let apiClient: APIClient = .stub(
      configuration: .init(
        baseURL: { URL(string: "https://awoiaf.westeros.org")! },
        httpHeaders: { [] },
        queryItems: { [] }
      ),
      request: .get("/some/resource/path/"),
      statusCode: 400,
      data: data
    )

    let result = try await apiClient.response(
      request: .get("/some/resource/path/"),
      responseHandler: APIClientResponseHandler<String, ErrorResponse>.shared(decoder: JSONDecoder())
    )

    switch result {
    case .success:
      XCTFail("\(Self.self) shouldn't have received a successful result.")
    case .failure(let error):
      switch error {
      case .httpError(let error):
        XCTAssertEqual((error.error as! ErrorResponse).code, 400)
        XCTAssertEqual((error.error as! ErrorResponse).message, "Bad request")
      default:
        XCTFail("\(Self.self) should have received an http error.")
      }
    }
  }
  
  func testErrorResponseFromJSON() async throws {
    let someError = """
    {
      "code": 400,
      "message": "Bad request"
    }
    """
    let data = someError.data(using: .utf8)
    let apiClient: APIClient = .stub(
      configuration: .init(
        baseURL: { URL(string: "https://awoiaf.westeros.org")! },
        httpHeaders: { [] },
        queryItems: { [] }
      ),
      request: .get("/some/resource/path/"),
      statusCode: 400,
      data: data
    )

    let result = try await apiClient.response(
      request: .get("/some/resource/path/"),
      responseHandler: APIClientResponseHandler<String, ErrorResponse>.shared(decoder: JSONDecoder())
    )

    switch result {
    case .success:
      XCTFail("\(Self.self) shouldn't have received a successful result.")
    case .failure(let error):
      switch error {
      case .httpError(let error):
        XCTAssertEqual((error.error as! ErrorResponse).code, 400)
        XCTAssertEqual((error.error as! ErrorResponse).message, "Bad request")
      default:
        XCTFail("\(Self.self) should have received an http error.")
      }
    }
  }

  // FIXME: Test APIClient with other HTTPMethods.
}
