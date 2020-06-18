//
//  TOTPGenerator.swift
//
// Copyright 2015 Codewise sp. z o.o. Sp. K.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Foundation

/**
 Time based OTP generator
 */
open class TOTPGenerator: OTPGenerator {

    /**
    Time period for which token is valid
     */
    fileprivate(set) open var period: TimeInterval

    /**
    Initializer for the time based generator.
     
    - parameter secret: Secret key on which generated keys will be based
    - parameter period: Time period for which token is valid
    - parameter pinLength: Length of generated tokens, must be between 1 and 8 digits, defaults to 6
    - parameter algorithm: Algorithm used for token generation, defaults to SHA1
    */
    public init?(secret: String, period: TimeInterval, pinLength: Int = 6, algorithm: OTPAlgorithm = OTPAlgorithm.sha1) {
        guard period > 0 || period <= 300 else {
            return nil
        }
        
        self.period = period
        super.init(secret: secret, pinLength: pinLength, algorithm: algorithm)
    }

    /**
    Generates next available token
    */
    open func generateOTP() -> String? {
        return self.generateOTP(date: Date())
    }

    /**
    Generates token for given date, defaults to now
    
    - parameter date: Date for which token is generated
    - returns: Generated token or nil
    */
    open func generateOTP(date: Date) -> String? {
        let seconds = date.timeIntervalSince1970
        let counter = uint_fast64_t(seconds / self.period)
        return self.generateOTP(counter: counter)
    }

}
