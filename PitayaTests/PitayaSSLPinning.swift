//
//  PitayaSSLPinningTests.swift
//  Pitaya
//
//  Created by 吕文翰 on 15/10/6.
//  Copyright © 2015年 http://lvwenhan.com. All rights reserved.
//

import XCTest
import Pitaya

class PitayaSSLPinning: BaseTestCase {
    
    var certData: NSData!
    
    override func setUp() {
        super.setUp()
        self.certData = NSData(contentsOfURL: self.URLForResource("lvwenhancom", withExtension: "cer"))!
    }
    
    func testSSLPiningPassed() {
        let expectation = expectationWithDescription("testSSLPiningPassed")
        
        Pita.build(HTTPMethod: .GET, url: "https://lvwenhan.com/")
            .addSSLPinning(LocalCertData: self.certData, SSLValidateErrorCallBack: { () -> Void in
                XCTFail("Under the Man-in-the-middle attack!")
            })
            .onNetworkError({ (error) -> Void in
                XCTAssert(false, error.localizedDescription)
            })
            .responseString { (string, response) -> Void in
                XCTAssert(string?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0)
                
                expectation.fulfill()
        }
        waitForExpectationsWithTimeout(self.defaultTimeout, handler: nil)
    }
    
    func testSSLPiningNotPassed() {
        let expectation = expectationWithDescription("testSSLPiningNotPassed")
        var errorPinning = 0
        
        Pita.build(HTTPMethod: .GET, url: "https://www.baidu.com/")
            .addSSLPinning(LocalCertData: self.certData, SSLValidateErrorCallBack: { () -> Void in
                print("Under the Man-in-the-middle attack!")
                errorPinning = 1
            })
            .onNetworkError({ (error) -> Void in
                XCTAssertNotNil(error)
                XCTAssert(errorPinning == 1, "Under the Man-in-the-middle attack")

                expectation.fulfill()
            })
            .responseString { (string, response) -> Void in
                XCTFail("shoud not run callback() after a Man-in-the-middle attack.")
        }
        
        waitForExpectationsWithTimeout(self.defaultTimeout, handler: nil)
    }
    
}
