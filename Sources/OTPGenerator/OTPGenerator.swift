//
//  OTPGenerator.swift
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
Encapsulates data for actual token generation.
*/
public enum OTPAlgorithm: Int {
    case sha1, sha256, sha512, md5

    var algorithm: CCHmacAlgorithm {
        switch self {
        case .sha1:   return CCHmacAlgorithm(kCCHmacAlgSHA1)
        case .sha256: return CCHmacAlgorithm(kCCHmacAlgSHA256)
        case .sha512: return CCHmacAlgorithm(kCCHmacAlgSHA512)
        case .md5:    return CCHmacAlgorithm(kCCHmacAlgMD5)
        }
    }

    var hashLength: Int32 {
        switch self {
        case .sha1:   return CC_SHA1_DIGEST_LENGTH
        case .sha256: return CC_SHA256_DIGEST_LENGTH
        case .sha512: return CC_SHA512_DIGEST_LENGTH
        case .md5:    return CC_MD5_DIGEST_LENGTH
        }
    }

}

protocol OTPGeneratorProtocol {
    func generateOTP(counter: UInt64) -> String?
    func generateOTP() -> String?
}

extension OTPGeneratorProtocol {
    /**
    Default implementation for method protocol method returns nil
     
    - returns: nil
    */
    public func generateOTP() -> String? {
        return nil
    }
}

/**
Base class for generator, this is a place where magic happens
*/
open class OTPGenerator: OTPGeneratorProtocol {
    
    fileprivate var secretKey: Data
    fileprivate var pinModeTable = [0, 10, 100, 1000, 10000, 100000, 1000000, 10000000, 100000000]
    fileprivate var pinLength: Int
    fileprivate var algorithm: OTPAlgorithm

    /**
    Base initializer for generators. It may fail if requested token length
    is out of bounds (too short or too long).
     
    - parameter secret: key on which generated keys will be based
    - parameter pinLength: Length of generated tokens, must be between 1 and 8 digits
    - parameter algorithm: Algorigthm used for token generation, defaults to SHA1
    */
    internal init?(secret: String, pinLength: Int = 6, algorithm: OTPAlgorithm = OTPAlgorithm.sha1) {
        guard let secretKey = secret.base32DecodedData, pinLength > 0 || pinLength <= 8 else {
            return nil
        }
        
        self.secretKey = secretKey as Data
        self.pinLength = pinLength
        self.algorithm = algorithm
    }

    /**
    Token generation for given counter. It uses CommonCrypto module
    to do actual token computing.
     
    - parameter counter: Value for which token is generated
    - returns: Generated token or nil
    */
    func generateOTP(counter: UInt64) -> String? {
        var newCounter = counter.bigEndian
        let counterData = Data(bytes: &newCounter, count: MemoryLayout.size(ofValue: newCounter))
        let algorithm: CCHmacAlgorithm = self.algorithm.algorithm

        let hashPtr = UnsafeMutablePointer<UInt8>.allocate(capacity: Int(self.algorithm.hashLength))
        defer { hashPtr.deallocate() }

        self.secretKey.withUnsafeBytes { secretBytes in
            counterData.withUnsafeBytes { counterBytes in
                CCHmac(algorithm, secretBytes, self.secretKey.count, counterBytes, counterData.count, hashPtr)
            }
        }

        let hash = Data(bytes: hashPtr, count: Int(self.algorithm.hashLength))
        var truncatedHash = hash.withUnsafeBytes { (ptr: UnsafePointer<UInt8>) -> UInt32 in
            let offset = ptr[hash.count - 1] & 0x0f
            let truncatedHashPtr = ptr + Int(offset)
            return truncatedHashPtr.withMemoryRebound(to: UInt32.self, capacity: 1) {
                $0.pointee
            }
        }
        truncatedHash = UInt32(bigEndian: truncatedHash)
        truncatedHash = truncatedHash & 0x7fffffff

        let pinValue = truncatedHash % UInt32(self.pinModeTable[self.pinLength])

        return String(format: "%0*u", self.pinLength, pinValue)
    }

}
