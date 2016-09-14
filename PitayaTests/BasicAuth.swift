//
//  BasicAuthTests.swift
//  Pitaya
//
//  Created by 吕文翰 on 15/10/8.
//  Copyright © 2015年 http://lvwenhan.com. All rights reserved.
//

import XCTest
import Pitaya

class BasicAuth: BaseTestCase {
    
    func testValidBasicAuth() {
        let expectation = self.expectation(description: "testBasicAuth")
        Pita.build(HTTPMethod: .GET, url: "http://httpbin.org/basic-auth/user/passwd")
            .setBasicAuth("user", password: "passwd")
            .onNetworkError({ (error) -> Void in
                XCTAssert(false, error.localizedDescription)
            })
            .responseData { (data, response) -> Void in
                XCTAssertEqual(response?.statusCode ?? 0, 200, "Basic Auth should get HTTP status 200")
                
                expectation.fulfill()
        }
        
        waitForExpectations(timeout: self.defaultTimeout, handler: nil)
    }
    
    func testInValidBasicAuth() {
        let expectation = self.expectation(description: "testInValidBasicAuth")
        Pita.build(HTTPMethod: .GET, url: "http://httpbin.org/basic-auth/user/passwd")
            .setBasicAuth("foo", password: "bar")
            .onNetworkError({ (error) -> Void in
                XCTAssert(false, error.localizedDescription)
            })
            .responseData { (data, response) -> Void in
                XCTAssertNotEqual(response?.statusCode, 200, "Basic Auth should get HTTP status 200")
                
                expectation.fulfill()
        }
        
        waitForExpectations(timeout: self.defaultTimeout, handler: nil)
    }
}
