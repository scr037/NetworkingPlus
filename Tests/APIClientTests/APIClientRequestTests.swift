import SnapshotTesting
import XCTest

@testable import APIClient

final class APIClientRequestTests: XCTestCase {
  let config = APIClientConfiguration(
    baseURL: { URL(string: "https://awoiaf.westeros.org")! },
    httpHeaders: {
      [
        HTTPHeader(key: "header_1", value: "value_1"),
        HTTPHeader(key: "header_2", value: "value_2"),
      ]
    },
    queryItems: {
      [
        URLQueryItem(name: "a_query_item", value: "a_value"),
        URLQueryItem(name: "another_query_item", value: "another_value"),
      ]
    }
  )

  func testSnapshotGet() {
    let sut = APIClientRequest.get("/some/path/")
    assertSnapshot(
      matching: sut.requestFrom(configuration: config),
      as: .raw(pretty: true)
    )
  }

  func testSnapshotGetReloaded() {
    let sut = APIClientRequest.get(
      "/some/path/",
      queryParams: [
        URLQueryItem(name: "appended_query_item", value: "a_random_value")
      ],
      httpHeaders: [
        HTTPHeader(key: "appended_header", value: "yet_another_value")
      ]
    )
    assertSnapshot(
      matching: sut.requestFrom(configuration: config),
      as: .raw(pretty: true)
    )
  }

  func testSnapshotPostReloaded() throws {
    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = .convertToSnakeCase

    let sut = try APIClientRequest.post(
      "/some/path/",
      queryParams: [
        URLQueryItem(name: "appended_query_item", value: "a_random_value")
      ],
      httpHeaders: [
        HTTPHeader(key: "appended_header", value: "yet_another_value")
      ],
      body: Body(intValue: 0, stringValue: "Yes"),
      encoder: encoder
    )
    assertSnapshot(
      matching: sut.requestFrom(configuration: config),
      as: .raw(pretty: true)
    )
  }
  
  func testSnapshotPutReloaded() throws {
    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = .convertToSnakeCase

    let sut = try APIClientRequest.put(
      "/some/path/",
      queryParams: [
        URLQueryItem(name: "appended_query_item", value: "a_random_value")
      ],
      httpHeaders: [
        HTTPHeader(key: "appended_header", value: "yet_another_value")
      ],
      body: Body(intValue: 0, stringValue: "Yes"),
      encoder: encoder
    )
    assertSnapshot(
      matching: sut.requestFrom(configuration: config),
      as: .raw(pretty: true)
    )
  }

  func testSnapshotDelete() {
    let sut = APIClientRequest.delete(
      "/some/path/",
      queryParams: [
        URLQueryItem(name: "appended_query_item", value: "a_random_value")
      ],
      httpHeaders: [
        HTTPHeader(key: "appended_header", value: "yet_another_value")
      ]
    )
    assertSnapshot(
      matching: sut.requestFrom(configuration: config),
      as: .raw(pretty: true)
    )
  }

  func testSnapshotHead() {
    let sut = APIClientRequest.head(
      "/some/path/",
      httpHeaders: [
        HTTPHeader(key: "appended_header", value: "yet_another_value")
      ]
    )
    assertSnapshot(
      matching: sut.requestFrom(configuration: config),
      as: .raw(pretty: true)
    )
  }
}

struct Body: Encodable {
  var intValue: Int
  var stringValue: String
}
