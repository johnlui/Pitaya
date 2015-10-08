//
//  BasicTests.swift
//  Pitaya
//
//  Created by 吕文翰 on 15/10/8.
//  Copyright © 2015年 http://lvwenhan.com. All rights reserved.
//

import XCTest
import Pitaya

class BasicTests: BaseTestCase {

    func testGET() {
        let expectation = expectationWithDescription("testGET")
        
        Pita.build(HTTPMethod: .GET, url: "http://staticonsae.sinaapp.com/pitaya.php")
            .onNetworkError({ (error) -> Void in
                XCTAssert(false, error.localizedDescription)
            })
            .responseString { (string, response) -> Void in
                XCTAssert(string == "", "GET should success and return empty string with no params")
                
                expectation.fulfill()
        }
        waitForExpectationsWithTimeout(self.defaultTimeout, handler: nil)
    }
    
    func testPOST() {
        let expectation = expectationWithDescription("testPOST")
        
        Pita.build(HTTPMethod: .POST, url: "http://staticonsae.sinaapp.com/pitaya.php")
            .onNetworkError({ (error) -> Void in
                XCTAssert(false, error.localizedDescription)
            })
            .responseString { (string, response) -> Void in
                XCTAssert(string == "", "POST should success and return empty string with no params")
                
                expectation.fulfill()
        }
        waitForExpectationsWithTimeout(self.defaultTimeout, handler: nil)
    }
}