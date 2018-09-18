import Foundation
import Just

public class Request {
  public let url: URL
  public var params: Params
  public let method: HTTPMethod
  public var data: [String: Any]?
  public var headers: Headers
  public var cookies: Cookies
  public var body: String?
  public var files: [String: HTTPFile] = [:]

  public init(
    method: HTTPMethod,
    url: URL,
    params: Params = Params(),
    data: [String: Any]? = nil,
    headers: Headers = Headers(),
    files: [String: HTTPFile] = [:],
    cookies: Cookies = Cookies(),
    body: String? = nil
  ) {
    self.method = method
    self.url = url
    self.data = data
    self.params = params
    self.headers = headers
    self.files = files
    self.body = body
    self.cookies = cookies
  }

  private var comp: URLComponents {
    var comp = URLComponents(url: url, resolvingAgainstBaseURL: true)!

    comp.queryItems = params.map { name, value in
      return URLQueryItem(name: name, value: value)
    }

    return comp
  }

  public var fullPath: String {
    return comp.url!.absoluteString
  }

  public func raw() throws -> Data? {
    guard let body = body else { return nil }
    guard let data = body.data(using: .utf8) else {
      throw "Could not convert \(body) to binary"
    }

    return data
  }

  public var query: String? {
    if let query = comp.query, !query.isEmpty {
      return query
    }

    return nil
  }

  public var path: String {
    if let query = self.query, !query.isEmpty {
      return comp.path + "?" + query
    }

    return comp.path
  }
}
