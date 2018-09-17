public func + <Key, Value>(lhs: [Key: Value], rhs: [Key: Value]) -> [Key: Value] {
  return lhs.merging(rhs) { _, new in new }
}
