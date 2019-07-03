import Foundation
import Just
import Logger
import SwiftyJSON

public class Hub {
  private let log: Logger
  private let host: URL
  private let params: Params
  private let cookies: Params
  private let session: JustOf<HTTP>
  private let maxRetries: Int = 5
  private let timeout: Double = 120.0

  public var delegate: Requestable?
  public typealias CachePolicy = NSURLRequest.CachePolicy

  public static func get(
    url: String,
    params: Params = Params(),
    headers: Headers = Headers(),
    cookies: Params = Params(),
    cachePolicy: CachePolicy = .reloadIgnoringLocalCacheData,
    logLevel: Level = .info
  ) throws -> HTTPData {
    guard let host = URL(string: url) else {
      throw "Could not convert \(url) to url"
    }

    let hub = Hub(
      host: host,
      cookies: cookies,
      cachePolicy: cachePolicy,
      logLevel: logLevel
    )

    return try hub.get(
      path: "/",
      params: params,
      headers: headers
    )
  }

  public static func post(
    url: String,
    params: Params = Params(),
    data: [String: Any]? = nil,
    files: [String: HTTPFile] = [:],
    json: Any? = nil,
    headers: Headers = Headers(),
    cookies: Params = Params(),
    cachePolicy: CachePolicy = .reloadIgnoringLocalCacheData,
    logLevel: Level = .info
  ) throws -> HTTPData {
    guard let host = URL(string: url) else {
      throw "Could not convert \(url) to url"
    }

    let hub = Hub(
      host: host,
      cookies: cookies,
      cachePolicy: cachePolicy,
      logLevel: logLevel
    )

    return try hub.post(
      path: "/",
      params: params,
      data: data,
      json: json,
      headers: headers
    )
  }

  public init(
    host: URL,
    params: Params = Params(),
    headers: Headers = Headers(),
    cookies: Params = Params(),
    cachePolicy: CachePolicy = .reloadIgnoringLocalCacheData,
    logLevel: Level = .info
  ) {
    let defaults = JustSessionDefaults(
      headers: headers,
      cachePolicy: cachePolicy
    )

    self.host = host
    self.params = params
    self.cookies = cookies
    self.log = Logger(logLevel, tags: ["Hub"])
    self.session = JustOf<HTTP>(defaults: defaults)
  }

  @discardableResult
  public func get(
    path: String,
    params: Params = Params(),
    headers: Headers = Headers()
  ) throws -> HTTPData {
    var endParams: [String: String]? = self.params + params
    if endParams!.isEmpty {
      endParams = nil
    }
    return try request(
      Request(
        method: .get,
        url: host + path,
        params: self.params + params,
        headers: headers
      )
    )
  }

  @discardableResult
  public func post(
    path: String,
    params: Params = Params(),
    data _data: [String: Any]? = nil,
    files: [String: HTTPFile] = [:],
    json _json: Any? = nil,
    headers: Headers = Headers()
  ) throws -> HTTPData {
    return try send(
      path: path,
      params: params,
      data: _data,
      json: _json,
      headers: headers,
      files: files,
      method: .post
    )
  }

  @discardableResult
  public func put(
    path: String,
    params: Params = Params(),
    data _data: [String: Any]? = nil,
    files: [String: HTTPFile] = [:],
    json _json: Any? = nil,
    headers: Headers = Headers()
  ) throws -> HTTPData {
    return try send(
      path: path,
      params: params,
      data: _data,
      json: _json,
      headers: headers,
      files: files,
      method: .put
    )
  }

  private func send(
    path: String,
    params: Params = Params(),
    data _data: [String: Any]? = nil,
    json _json: Any? = nil,
    headers: Headers = Headers(),
    files: [String: HTTPFile] = [:],
    method: HTTPMethod
  ) throws -> HTTPData {
    var json: String?
    var data: [String: Any]?

    switch (_json, _data) {
    case let (.some(data), .none):
      guard let maybeJSON = JSON(data).rawString() else {
        throw "Could not convert JSON to String"
      }

      json = maybeJSON
    case let (.none, .some(raw)):
      data = raw
    case (.none, .none):
      data = [:]
    default:
      throw "Both data: and json: cannot be defined"
    }

    return try request(
      Request(
        method: method,
        url: host + path,
        params: self.params + params,
        data: data,
        headers: headers,
        files: files,
        body: json
      )
    )
  }

  private func request(_ request: Request, retries: Int = 0) throws -> HTTPData {
    try delegate?.onWillSend(request: request)
    let body = try request.raw()
    let url = request.fullPath
    let data = request.data ?? [:]
    let headers = request.headers
    let method = request.method
    let cookies = self.cookies + request.cookies
    let none = "<NONE>".red

    log.verbose(method.rawValue, url, tag: "Input") { list in
      list.kv("Body", request.body ?? none)

      if request.params.isEmpty {
        list.kv("Params", none)
      } else {
        list.kv("Params", request.params)
      }

      if headers.isEmpty {
        list.kv("Headers", none)
      } else {
        list.kv("Headers", headers)
      }

      if cookies.isEmpty {
        list.kv("Cookies", none)
      } else {
        list.kv("Cookies", cookies)
      }

      if request.files.isEmpty {
        list.kv("Files", none)
      } else {
        list.kv("Files", request.files)
      }

      list.kv("Retries", retries)
      list.kv("Timeout", self.timeout)

      if data.isEmpty {
        list.kv("Data", none)
      } else {
        list.kv("Data", data)
      }
    }

    let response = session.request(
      method,
      url: url,
      params: [:],
      data: data,
      json: nil,
      headers: headers,
      files: request.files,
      auth: nil,
      cookies: cookies,
      allowRedirects: true,
      timeout: timeout,
      urlQuery: nil,
      requestBody: body,
      asyncProgressHandler: nil,
      asyncCompletionHandler: nil
    )

    let statusStr = String(response.status)
    let okStatus = response.ok ? statusStr.green : statusStr.red

    log.verbose(okStatus, method.rawValue, url, tag: "Output") { list in
      list.kv("Response", response)
      list.kv("Body", response.text ?? "<NO BODY>")
      list.kv("Status", response.status)
      list.kv("Request", response.desc)

      let none = "<NONE>".red

      if let json = response.json {
        list.kv("JSON", json)
      }

      if let error = response.error {
        list.kv("Error", error)
      }

      list.kv("Is redirect", response.isRedirect)
      list.kv("Reason", response.reason)
      list.kv("Encoding", response.encoding)

      if response.cookies.isEmpty {
        list.kv("Cookies", none)
      } else {
        list.kv("Cookies", response.cookies)
      }

      if response.headers.isEmpty {
        list.kv("Headers", none)
      } else {
        list.kv("Headers", response.headers)
      }

      if response.links.isEmpty {
        list.kv("Links", none)
      } else {
        list.kv("Links", response.links)
      }
    }

    let httpData = HTTPData(
      request: response
    )

    try delegate?.onDidSend(response: httpData)

    if httpData.ok {
      return httpData
    }

    if httpData.status == -1 && retries < maxRetries {
      log.debug("Request was aborted. Timeout or no internet, retry")
      return try self.request(request, retries: retries + 1)
    } else if httpData.status == -1 {
      throw "Request was aborted. Timeout or no internet"
    }

    guard let status = delegate?.onFailure(response: httpData) else {
      return httpData
    }

    switch status {
    case .retry where retries < maxRetries:
      log.debug("Manual retry: \(retries)")
      return try self.request(request, retries: retries + 1)
    case .retry: // Max retries
      log.debug("Max retries reached of \(retries)")
      return httpData
    case .fail:
      log.debug("Manual fail")
      return httpData
    }
  }
}
