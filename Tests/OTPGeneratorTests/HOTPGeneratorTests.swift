import XCTest
@testable import OTPGenerator

final class HOTPGeneratorTests: XCTestCase {
    
    var generator: HOTPGenerator!
    
    override func setUp() {
        super.setUp()
        self.generator = HOTPGenerator(secret: "test", counter: 0)
    }
    
    override func tearDown() {
        super.tearDown()
        self.generator = nil
    }
    
    func testHOTP() {
        guard let hotp = generator else {
            XCTFail("Unable to create HOTPGenerator")
            return
        }
        
        let code = hotp.generateOTP(counter: 0)
        XCTAssertEqual(code, "642887")
    }
    
    func testHOTPDifferentWithDifferentCounters() {
        guard let hotp = generator else {
            XCTFail("Unable to create HOTPGenerator")
            return
        }
        
        let code1 = hotp.generateOTP(counter: 0)
        let code2 = hotp.generateOTP(counter: 1)
        XCTAssertNotEqual(code1, code2)
    }
    
    func testHOTPSameWithSameCounter() {
        guard let hotp = generator else {
            XCTFail("Unable to create HOTPGenerator")
            return
        }
        
        let code1 = hotp.generateOTP(counter: 111)
        let code2 = hotp.generateOTP(counter: 111)
        XCTAssertEqual(code1, code2)
    }
    
    func testTOTPWithCounterIncrease() {
        guard let hotp = generator else {
            XCTFail("Unable to create TOTPGenerator")
            return
        }
        
        let code1 = hotp.generateOTP()
        let code2 = hotp.generateOTP()
        XCTAssertNotEqual(code1, code2)
    }

    static var allTests = [
        ("testHOTP", testHOTP),
        ("testHOTPDifferentWithDifferentCounters", testHOTPDifferentWithDifferentCounters),
        ("testHOTPSameWithSameCounter", testHOTPSameWithSameCounter),
        ("testTOTPWithCounterIncrease", testTOTPWithCounterIncrease)
    ]
}
