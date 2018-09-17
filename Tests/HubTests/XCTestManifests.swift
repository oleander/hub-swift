import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(hub_swiftTests.allTests),
    ]
}
#endif