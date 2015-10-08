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
    let defaultTimeout: NSTimeInterval = 10
    
    func URLForResource(fileName: String, withExtension: String) -> NSURL {
        let bundle = NSBundle(forClass: BaseTestCase.self)
        return bundle.URLForResource(fileName, withExtension: withExtension)!
    }
    
    func randomStringWithLength(len : Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789我就测试一下UTF-8"
        
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for (var i=0; i < len; i++){
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        return randomString as String
    }
}
