import AEXML
import Logger
import Foundation
import Just
import Kanna
import SwiftyJSON

public typealias Headers = [String: String]
public typealias Cookies = [String: String]
public typealias Params = Headers

public class HTTPData {
  public typealias JSON = SwiftyJSON.JSON
  public typealias HTML = HTMLDocument
  public typealias XML = AEXMLDocument
  private let log = Logger.new("Data")

  private let request: HTTPResult

  public init(request: HTTPResult) {
    self.request = request
  }

  public var status: Int {
    return request.status
  }

  public var ok: Bool {
    return request.ok
  }

  public func check() throws {
    guard request.ok else {
      throw "Bad respose (\(request.status)): \(request): \(text ?? "<NONE>")"
    }
  }

  public func xml() throws -> XML {
    return try AEXMLDocument(xml: try data())
  }

  public func json(throwOnError: Bool = true) throws -> JSON {
    return JSON(data: try data(throwOnError: throwOnError))
  }

  public func html() throws -> HTML {
    return try Kanna.HTML(html: try data(), encoding: .utf8)
  }

  public var text: String? {
    return request.text
  }

  public func responded(with value: String) -> Bool {
    guard let text = text else {
      return false
    }

    return text.contains(value)
  }

  public func raw(throwOnError: Bool = true) throws -> String {
    if throwOnError {
      try check()
    }

    guard let text = request.text else {
      throw "No response: \(request)"
    }

    return text
  }

  public func data(throwOnError: Bool = true) throws -> Data {
    guard let data = try raw(throwOnError: throwOnError).data(using: .utf8, allowLossyConversion: false) else {
      throw "Could not convert text '\(try raw())' to binary"
    }

    return data
  }
}
