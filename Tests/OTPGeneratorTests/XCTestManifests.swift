import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(OTPGeneratorTests.allTests),
    ]
}
#endif
