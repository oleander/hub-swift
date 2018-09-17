import Foundation
import Just
import SwiftyJSON

public extension HTTPResult {
  private typealias JSON = SwiftyJSON.JSON

  public var status: Int {
    return statusCode != nil ? statusCode! : -1
  }

  public var method: String {
    return request?.httpMethod?.uppercased() ?? "<NONE>"
  }

  public var badge: String {
    return ok ? String(status).green : String(status).red
  }

  public var path: String {
    return url?.path ?? "<NONE>"
  }

  public var desc: String {
    return "[\(badge)] \(method) \(path)"
  }
}
