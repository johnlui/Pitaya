//
//  WithParams.swift
//  Pitaya
//
//  Created by 吕文翰 on 15/10/8.
//  Copyright © 2015年 http://lvwenhan.com. All rights reserved.
//

import XCTest
import Pitaya

class WithParams: BaseTestCase {
    
    var param1: String!
    var param2: String!
    
    override func setUp() {
        super.setUp()
        
        self.param1 = randomStringWithLength(200)
        self.param2 = randomStringWithLength(200)
    }
    
    func testGETWithParams() {
        let expectation = expectationWithDescription("testGETWithParams")
        
        Pita.build(HTTPMethod: HTTPMethod.GET, url: "http://staticonsae.sinaapp.com/pitaya.php")
            .addParams(["get": param1, "get2": param2])
            .onNetworkError({ (error) -> Void in
                XCTAssert(false, error.localizedDescription)
            })
            .responseString { (string, response) -> Void in
                XCTAssert(string == self.param1 + self.param2, "GET should success and return the strings together")
                
                expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(self.defaultTimeout, handler: nil)
    }
    
    func testPOSTWithParams() {
        let expectation = expectationWithDescription("testPOSTWithParams")
        
        Pita.build(HTTPMethod: HTTPMethod.GET, url: "http://staticonsae.sinaapp.com/pitaya.php")
            .addParams(["get": param1, "get2": param2])
            .onNetworkError({ (error) -> Void in
                XCTAssert(false, error.localizedDescription)
            })
            .responseString({ (string, response) -> Void in
                XCTAssert(string == self.param1 + self.param2, "GET should success and return the strings together")
                
                expectation.fulfill()
            })
        
        waitForExpectationsWithTimeout(self.defaultTimeout, handler: nil)
    }
}