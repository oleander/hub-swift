import Foundation
import Just

public extension URL {
  public static func + (url: URL, path: String) -> URL {
    return url.appendingPathComponent(path)
  }

  public static func + (url: URL, paths: [String]) -> URL {
    return paths.reduce(url) { url, path in url + path }
  }
}
