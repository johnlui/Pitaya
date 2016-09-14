//
//  PitayaTests.swift
//  PitayaTests
//
//  Created by JohnLui on 15/7/24.
//  Copyright (c) 2015年 http://lvwenhan.com. All rights reserved.
//

import XCTest
import Pitaya

class BaseTestCase: XCTestCase {
    let defaultTimeout: TimeInterval = 60
    let defaultFileUploadTimeout: TimeInterval = 600
    
    func URLForResource(_ fileName: String, withExtension: String) -> URL {
        let bundle = Bundle(for: BaseTestCase.self)
        return bundle.url(forResource: fileName, withExtension: withExtension)!
    }
    
    func randomStringWithLength(_ len : Int, onlyASCII: Bool = false) -> String {
        
        let letters : NSString = onlyASCII ? "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" : "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789我就测试一下UTF-8"
        
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for _ in 0..<len {
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.character(at: Int(rand)))
        }
        
        return randomString as String
    }
}
