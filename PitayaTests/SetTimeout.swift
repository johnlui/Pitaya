//
//  SetTimeout.swift
//  Pitaya
//
//  Created by 吕文翰 on 17/2/20.
//  Copyright © 2017年 http://lvwenhan.com. All rights reserved.
//

import XCTest
import Pitaya

class SetTimeout: BaseTestCase {
    
    func testSetTimeoutSuccess() {
        let expectation = self.expectation(description: "testSetTimeoutSuccess")

        Pita.build(HTTPMethod: .GET, url: "http://httpbin.org/delay/5", timeout: 8)
            .onNetworkError({ (error) -> Void in
                XCTAssert(false, error.localizedDescription)
            })
            .responseJSON { (json, response) -> Void in
                XCTAssertEqual(json["url"].stringValue, "http://httpbin.org/delay/5")
                expectation.fulfill()
        }
        waitForExpectations(timeout: self.defaultTimeout, handler: nil)
    }
    
    func testSetTimeoutFail() {
        let expectation = self.expectation(description: "testSetTimeoutFail")
        
        Pita.build(HTTPMethod: .GET, url: "http://httpbin.org/delay/5", timeout: 2)
            .onNetworkError({ (error) -> Void in
                expectation.fulfill()
            })
            .responseJSON { (json, response) -> Void in
                XCTAssertEqual(json["url"].stringValue, "http://httpbin.org/delay/5")
        }
        waitForExpectations(timeout: self.defaultTimeout, handler: nil)
    }
}
