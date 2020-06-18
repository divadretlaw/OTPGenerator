import XCTest
@testable import OTPGenerator

final class OTPGeneratorTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(OTPGenerator().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
