import XCTest
@testable import OTPGenerator

final class TOTPGeneratorTests: XCTestCase {
    
    var generator: TOTPGenerator!
    
    override func setUp() {
        super.setUp()
        self.generator = TOTPGenerator(secret: "test", period: 30)
    }
    
    override func tearDown() {
        super.tearDown()
        self.generator = nil
    }
    
    func testTOTP() {
        guard let totp = generator else {
            XCTFail("Unable to create TOTPGenerator")
            return
        }
        
        let date = Date(timeIntervalSince1970: 0)
        let code = totp.generateOTP(date: date)
        XCTAssertEqual(code, "642887")
    }
    
    func testTOTPDifferentAfterFullPeriod() {
        guard let totp = generator else {
            XCTFail("Unable to create TOTPGenerator")
            return
        }
        
        let date1 = Date(timeIntervalSince1970: 0)
        let date2 = Date(timeIntervalSince1970: generator.period)
        
        let code1 = totp.generateOTP(date: date1)
        let code2 = totp.generateOTP(date: date2)
        XCTAssertNotEqual(code1, code2)
    }
    
    func testTOTPSameAfterLessThanPeriod() {
        guard let totp = generator else {
            XCTFail("Unable to create TOTPGenerator")
            return
        }
        
        let date1 = Date(timeIntervalSince1970: 0)
        let date2 = Date(timeIntervalSince1970: generator.period / 2)
        
        let code1 = totp.generateOTP(date: date1)
        let code2 = totp.generateOTP(date: date2)
        XCTAssertEqual(code1, code2)
    }
    
    func testTOTPDifferentAfterMultiplePeriods() {
        guard let totp = generator else {
            XCTFail("Unable to create TOTPGenerator")
            return
        }
        
        let date1 = Date(timeIntervalSince1970: 0)
        let date2 = Date(timeIntervalSince1970: generator.period * 3)
        
        let code1 = totp.generateOTP(date: date1)
        let code2 = totp.generateOTP(date: date2)
        XCTAssertNotEqual(code1, code2)
    }

    static var allTests = [
        ("testTOTP", testTOTP),
        ("testTOTPDifferentAfterFullPeriod", testTOTPDifferentAfterFullPeriod),
        ("testTOTPSameAfterLessThanPeriod", testTOTPSameAfterLessThanPeriod),
        ("testTOTPDifferentAfterMultiplePeriods", testTOTPDifferentAfterMultiplePeriods)
    ]
}
