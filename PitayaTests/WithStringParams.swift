//
//  WithParams.swift
//  Pitaya
//
//  Created by 吕文翰 on 15/10/8.
//  Copyright © 2015年 http://lvwenhan.com. All rights reserved.
//

import XCTest
import Pitaya

class WithStringParams: BaseTestCase {
    
    var param1: String!
    var param2: String!
    
    override func setUp() {
        super.setUp()
        
        self.param1 = randomStringWithLength(200)
        self.param2 = randomStringWithLength(200)
    }
    
    func testGETWithParams() {
        let expectation = self.expectation(description: "testGETWithParams")
        
        Pita.build(HTTPMethod: .GET, url: "http://tinylara.com:8000/pitaya.php")
            .addParams(["get": param1, "get2": param2])
            .onNetworkError({ (error) -> Void in
                XCTAssert(false, error.localizedDescription)
            })
            .responseString { (string, response) -> Void in
                XCTAssert(string == self.param1 + self.param2, "GET should success and return the strings together")
                
                expectation.fulfill()
        }
        
        waitForExpectations(timeout: self.defaultTimeout, handler: nil)
    }
    
    func testPOSTWithParams() {
        let expectation = self.expectation(description: "testPOSTWithParams")
        
        Pita.build(HTTPMethod: .POST, url: "http://tinylara.com:8000/pitaya.php")
            .addParams(["post": param1, "post2": param2])
            .onNetworkError({ (error) -> Void in
                XCTAssert(false, error.localizedDescription)
            })
            .responseString({ (string, response) -> Void in
                XCTAssert(string == self.param1 + self.param2, "GET should success and return the strings together")
                
                expectation.fulfill()
            })
        
        waitForExpectations(timeout: self.defaultTimeout, handler: nil)
    }
}
