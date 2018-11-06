import Foundation
import SwiftyJSON

extension JSON {
  private func convert(_ key: String) -> JSON {
    return key
      .components(separatedBy: ".")
      .reduce(self) { acc, key in acc[key] }
  }

  public func get<T>(_ key: String, default backup: T? = nil) throws -> T {
    guard let value = convert(key).object as? T else {
      if let that = backup { return that }
      else { throw error(for: key) }
    }

    return value
  }

  public func get(array key: String) throws -> [JSON] {
    return try get(key)
  }

  private func error(for key: String) -> String {
    return "Could get key '\(key)' in \(rawString() ?? "N/A")"
  }

  public func get(string key: String) throws -> String {
    guard let value = convert(key).string else {
      throw error(for: key)
    }

    return value
  }

  public func get(double key: String) throws -> Double {
    guard let value = convert(key).double else {
      throw error(for: key)
    }

    return value
  }

  public func get(bool key: String) throws -> Bool {
    guard let value = convert(key).bool else {
      throw error(for: key)
    }

    return value
  }

  public func get(int key: String) throws -> Int {
    guard let value = convert(key).int else {
      throw error(for: key)
    }

    return value
  }
}
