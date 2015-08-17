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
    func testBaseRequest() {
        // Basic GET and POST
        Pitaya.request(.GET, url: "http://staticonsae.sinaapp.com/pitaya.php", errorCallback: { (error) -> Void in
            XCTAssert(false, error.localizedDescription)
            }) { (data, response) -> Void in
                let string = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
                XCTAssert(string == "", "GET should success and return empty string with no params")
        }
        Pitaya.request(.POST, url: "http://staticonsae.sinaapp.com/pitaya.php", errorCallback: { (error) -> Void in
            XCTAssert(false, error.localizedDescription)
            }) { (data, response) -> Void in
                let string = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
                XCTAssert(string == "", "POST should success and return empty string with no params")
        }
    }
    
    func testRequestWithParams() {
        // GET and POST with params
        let param1 = randomStringWithLength(200)
        let param2 = randomStringWithLength(200)
        
        Pitaya.request(.GET, url: "http://staticonsae.sinaapp.com/pitaya.php", params: ["get": param1, "get2": param2], errorCallback: { (error) -> Void in
            XCTAssert(false, error.localizedDescription)
            }) { (data, response) -> Void in
                let string = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
                XCTAssert(string == param1 + param2, "GET should success and return the strings together")
        }
        Pitaya.request(.POST, url: "http://staticonsae.sinaapp.com/pitaya.php", params: ["post": param1, "post2": param2], errorCallback: { (error) -> Void in
            XCTAssert(false, error.localizedDescription)
            }) { (data, response) -> Void in
                let string = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
                XCTAssert(string == param1 + param2, "POST should success and return the strings together")
        }
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
    
    func testAddParamsFunction() {
        let param1 = randomStringWithLength(200)
        let param2 = randomStringWithLength(200)
        
        var pitaya = PitayaManager.build(.GET, url: "http://staticonsae.sinaapp.com/pitaya.php")
        pitaya.addParams(["get": param1, "get2": param2])
        pitaya.fire({ (error) -> Void in
            XCTAssert(false, error.localizedDescription)
            }) { (data, response) -> Void in
                let string = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
                XCTAssert(string == param1 + param2, "GET should success and return the strings together")
        }
        
        pitaya = PitayaManager.build(.POST, url: "http://staticonsae.sinaapp.com/pitaya.php")
        pitaya.addParams(["post": param1, "post2": param2])
        pitaya.fire({ (error) -> Void in
            XCTAssert(false, error.localizedDescription)
            }) { (data, response) -> Void in
                let string = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
                XCTAssert(string == param1 + param2, "POST should success and return the strings together")
        }
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
        sleep(10) // wait Network for 5 seconds
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
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
