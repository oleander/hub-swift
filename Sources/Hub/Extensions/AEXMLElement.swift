import AEXML

public extension AEXMLElement {
  public func get<T>(_ key: String) throws -> T {
    let xml = key.components(separatedBy: ".").reduce(self) { acc, key in acc[key] }
    let error = "Could not convert \(self) with key '\(key)'"

    if let value = xml.double as? T {
      return value
    } else if let value = xml.string as? T {
      return value
    }

    throw error
  }
}
