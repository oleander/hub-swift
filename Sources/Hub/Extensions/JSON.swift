import Foundation
import SwiftyJSON

extension JSON {
  public func get<T>(_ key: String, default backup: T? = nil) throws -> T {
    let json = key.components(separatedBy: ".").reduce(self) { acc, key in acc[key] }
    guard let value = json.object as? T else {
      if let that = backup { return that }
      throw "Could not convert key \(key) to type \(T.self)"
    }

    return value
  }

  public func get(array key: String) throws -> [JSON] {
    return try get(key)
  }

  public func get(string key: String) throws -> String {
    return try get(key)
  }

  public func get(double key: String) throws -> Double {
    return try get(key)
  }

  public func get(bool key: String) throws -> Bool {
    return try get(key)
  }

  public func get(int key: String) throws -> Int {
    return try get(key)
  }
}
