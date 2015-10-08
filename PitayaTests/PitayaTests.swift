//
//  PitayaTests.swift
//  PitayaTests
//
//  Created by JohnLui on 15/5/14.
//  Copyright (c) 2015年 http://lvwenhan.com. All rights reserved.
//

import UIKit
import XCTest
import Pitaya

class PitayaTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testFileUpload() {
        /* --------------------------
        *    NOTICE: you must copy Pitaya.png in "Supporting Files" directory to /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/Library/Xcode/Agents
        *  --------------------------
        */
        let file = File(name: "file", url: NSBundle(forClass: PitayaTests.self).URLForResource("Pitaya", withExtension: "png")!)
        Pitaya.request(.POST, url: "http://staticonsae.sinaapp.com/pitaya.php", files: [file], errorCallback: { (error) -> Void in
            XCTAssert(false, error.localizedDescription)
            }) { (data, response) -> Void in
                let string = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
                XCTAssert(string == "1", "file upload")
        }
    }
    
    func testAuth() {
        let expectation = expectationWithDescription("401")
        var res: NSHTTPURLResponse?
        let pitaya = PitayaManager.build(.GET, url: "http://httpbin.org/basic-auth/user/passwd")
        pitaya.fireWithBasicAuth(("user", "passwd"), errorCallback: { (error) -> Void in
            XCTAssert(false, error.localizedDescription)
            }) { (data, response) -> Void in
                res = response
                
                expectation.fulfill()
        }
        waitForExpectationsWithTimeout(10, handler: nil)
        XCTAssertEqual(res?.statusCode ?? 0, 200, "Basic Auth should get HTTP status 200")
    }

    func testAddFilesFunction() {
        let pitaya = PitayaManager.build(.POST, url: "http://staticonsae.sinaapp.com/pitaya.php")
        let file = File(name: "file", url: NSBundle(forClass: PitayaTests.self).URLForResource("Pitaya", withExtension: "png")!)
        pitaya.addFiles([file])
        pitaya.fire({ (error) -> Void in
            XCTAssert(false, error.localizedDescription)
            }) { (data, response) -> Void in
                let string = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
                XCTAssert(string == "1", "file upload")
        }
    }
    
    func testWait() {
        sleep(10) // wait Network for 10 seconds
    }    
}
