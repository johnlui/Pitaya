//
//  AddHTTPHeader.swift
//  Pitaya
//
//  Created by leqicheng on 15/10/16.
//  Copyright © 2015年 http://lvwenhan.com. All rights reserved.
//

import XCTest
import Pitaya

class AddHTTPHeader: BaseTestCase {
    
    func testAddHTTPHeader() {
        let expectation = self.expectation(description: "testAddHTTPHeader")
        
        let name = "Accept"
        let value = "application/json"

        Pita.build(HTTPMethod: .GET, url: "http://httpbin.org/headers")
            .setHTTPHeader(Name: name, Value: value)
            .onNetworkError({ (error) -> Void in
                XCTAssert(false, error.localizedDescription)
            })
            .responseJSON { (json, response) -> Void in
                XCTAssertEqual(json["headers"][name].stringValue, value)
                expectation.fulfill()
        }
        
        waitForExpectations(timeout: self.defaultTimeout, handler: nil)
    }
}
