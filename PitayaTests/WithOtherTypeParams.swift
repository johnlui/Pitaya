//
//  WithOtherTypeParams.swift
//  Pitaya
//
//  Created by 吕文翰 on 16/10/3.
//  Copyright © 2016年 http://lvwenhan.com. All rights reserved.
//

import XCTest
import Pitaya

class WithOtherTypeParams: BaseTestCase {
    
    var intParam = 2016
    var doubleParam = 2.48
    var boolParam = true
    
    override func setUp() {
        super.setUp()
    }
    func testGETWithParams() {
        let expectation = self.expectation(description: "testGETWithParams")
        
        Pita.build(HTTPMethod: .GET, url: "http://httpbin.org/get")
            .addParams(["a": self.intParam, "b": self.doubleParam, "c": self.boolParam])
            .onNetworkError({ (error) -> Void in
                XCTAssert(false, error.localizedDescription)
            })
            .responseJSON { (json, nil) in
                XCTAssert(json["args"]["a"].intValue == self.intParam, "GET should success and return intParam")
                XCTAssert(json["args"]["b"].doubleValue == self.doubleParam, "GET should success and return doubleParam")
                
                // bool value in httpbin.org will be treated as string
                XCTAssert(json["args"]["c"].stringValue == self.boolParam.description, "GET should success and return boolParam")
                
                expectation.fulfill()
        }
        
        waitForExpectations(timeout: self.defaultTimeout, handler: nil)
    }
    
    func testPOSTWithParams() {
        let expectation = self.expectation(description: "testPOSTWithParams")
        
        Pita.build(HTTPMethod: .POST, url: "http://httpbin.org/post")
            .addParams(["a": self.intParam, "b": self.doubleParam, "c": self.boolParam])
            .onNetworkError({ (error) -> Void in
                XCTAssert(false, error.localizedDescription)
            })
            .responseJSON { (json, nil) in
                XCTAssert(json["form"]["a"].intValue == self.intParam, "GET should success and return intParam")
                XCTAssert(json["form"]["b"].doubleValue == self.doubleParam, "GET should success and return doubleParam")
                
                // bool value in httpbin.org will be treated as string
                XCTAssert(json["form"]["c"].stringValue == self.boolParam.description, "GET should success and return boolParam")
                
                expectation.fulfill()
        }

        waitForExpectations(timeout: self.defaultTimeout, handler: nil)
    }
}
