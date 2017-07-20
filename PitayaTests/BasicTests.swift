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
        let expectation = self.expectation(description: "testGET")
        
        Pita.build(HTTPMethod: .GET, url: "http://tinylara.com:8000/pitaya.php")
            .onNetworkError({ (error) -> Void in
                XCTAssert(false, error.localizedDescription)
            })
            .responseString { (string, response) -> Void in
                XCTAssert(string == "", "GET should success and return empty string with no params")
                
                expectation.fulfill()
        }
        waitForExpectations(timeout: self.defaultTimeout, handler: nil)
    }
    
    func testPOST() {
        let expectation = self.expectation(description: "testPOST")
        
        Pita.build(HTTPMethod: .POST, url: "http://tinylara.com:8000/pitaya.php")
            .onNetworkError({ (error) -> Void in
                XCTAssert(false, error.localizedDescription)
            })
            .responseString { (string, response) -> Void in
                XCTAssert(string == "", "POST should success and return empty string with no params")
                
                expectation.fulfill()
        }
        waitForExpectations(timeout: self.defaultTimeout, handler: nil)
    }
    
    func testOneMoreThing() {
        // code here will not be used in reality forever, just for increasing testing coverage
        
        let expectation = self.expectation(description: "testOneMoreThing")
        Pitaya.DEBUG = true
        Pita.build(HTTPMethod: .GET, url: "http://tinylara.com:8000/pitaya.php")
            .responseString { (string, response) -> Void in
                XCTAssert(string == "", "GET should success and return empty string with no params")
                
                expectation.fulfill()
        }
        waitForExpectations(timeout: self.defaultTimeout, handler: nil)
    }
}
