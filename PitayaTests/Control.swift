//
//  Control.swift
//  Pitaya
//
//  Created by 吕文翰 on 15/12/25.
//  Copyright © 2015年 http://lvwenhan.com. All rights reserved.
//

import XCTest
import Pitaya

class Control: BaseTestCase {
    
    func testCancel() {
        let expectation = self.expectation(description: "testCancel")
        
        let pita = Pita.build(HTTPMethod: .GET, url: "http://httpbin.org/")
            .onNetworkError({ (error) -> Void in
                XCTAssert(false, error.localizedDescription)
            })
        pita.responseString { (string, response) -> Void in
            XCTFail("the request should be cancelled")
            
            expectation.fulfill()
        }
        pita.cancel { () -> Void in
            expectation.fulfill()
        }
        waitForExpectations(timeout: self.defaultTimeout, handler: nil)
    }
    
}
