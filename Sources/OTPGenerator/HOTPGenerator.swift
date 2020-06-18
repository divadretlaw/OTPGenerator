//
// HOTPGenerator.swift
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
 Counter based generator
 */
open class HOTPGenerator: OTPGenerator {

    // The counter, incremented on each generated OTP.
    fileprivate var counter: uint_fast64_t = 0

    /**
     Initializer for the counter based generator.
     
     - parameter secret: Secret key on which generated keys will be based
     - parameter counter: Initial value for counter
     - parameter pinLength: Length of generated tokens, must be between 1 and 8 digits, defaults to 6
     - parameter algorithm: Algorithm used for token generation, defaults to SHA1
     */
    public init?(secret: String, counter: uint_fast64_t, pinLength: Int = 6, algorithm: OTPAlgorithm = OTPAlgorithm.sha1) {
        self.counter = counter
        super.init(secret: secret, pinLength: pinLength, algorithm: algorithm)
    }

    /**
     Generates next available token

     - returns: Generated token or nil
     */
    open func generateOTP() -> String? {
        self.counter += 1
        return self.generateOTP(counter: self.counter)
    }

}
