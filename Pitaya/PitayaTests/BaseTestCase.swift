//
//  PitayaTests.swift
//  PitayaTests
//
//  Created by JohnLui on 15/7/24.
//  Copyright (c) 2015年 http://lvwenhan.com. All rights reserved.
//

import UIKit
import XCTest
import Pitaya

class BaseTestCase: XCTestCase {
    let defaultTimeout: NSTimeInterval = 10
    
    func URLForResource(fileName: String, withExtension: String) -> NSURL {
        let bundle = NSBundle(forClass: BaseTestCase.self)
        return bundle.URLForResource(fileName, withExtension: withExtension)!
    }
}
