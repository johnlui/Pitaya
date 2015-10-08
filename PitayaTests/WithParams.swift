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
    
    func testGETWithParams() {
        let param1 = randomStringWithLength(200)
        let param2 = randomStringWithLength(200)
        
        let expectation = expectationWithDescription("testGETWithParams")
        
        Pita.build(HTTPMethod: HTTPMethod.GET, url: "http://staticonsae.sinaapp.com/pitaya.php")
            .addParams(["get": param1, "get2": param2])
            .onNetworkError({ (error) -> Void in
                XCTAssert(false, error.localizedDescription)
                
                expectation.fulfill()
            })
            .responseString { (string, response) -> Void in
                XCTAssert(string == param1 + param2, "GET should success and return the strings together")
                
                expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(self.defaultTimeout, handler: nil)
    }
    
    func testPOSTWithParams() {
        let param1 = randomStringWithLength(200)
        let param2 = randomStringWithLength(200)
        
        let expectation = expectationWithDescription("testPOSTWithParams")
        
        Pita.build(HTTPMethod: HTTPMethod.GET, url: "http://staticonsae.sinaapp.com/pitaya.php")
            .addParams(["get": param1, "get2": param2])
            .onNetworkError({ (error) -> Void in
                XCTAssert(false, error.localizedDescription)
            })
            .responseString({ (string, response) -> Void in
                XCTAssert(string == param1 + param2, "GET should success and return the strings together")
                
                expectation.fulfill()
            })
        
        waitForExpectationsWithTimeout(self.defaultTimeout, handler: nil)
    }
}