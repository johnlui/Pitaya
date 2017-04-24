//
//  SetSync.swift
//  Pitaya
//
//  Created by ZhuFaner on 2017/4/24.
//  Copyright © 2017年 http://lvwenhan.com. All rights reserved.
//

import XCTest
import Pitaya

class SetSync: BaseTestCase {
    
    func testSyncExecutionSuccess(){
        let current = Date()
        Pitaya.build(HTTPMethod: .GET, url: "http://httpbin.org/delay/5", timeout: 10, execution: .sync).onNetworkError { (error) in
            XCTAssert(false, error.localizedDescription)
        }.responseJSON { (json, response) in
            XCTAssertEqual(json["url"].stringValue, "http://httpbin.org/delay/5")
        }
        
        XCTAssert(Date().timeIntervalSince(current) >= 5, "sync execution failed")
    }
    
    func testSyncExecutionTimeout(){
        let current = Date()
        Pitaya.build(HTTPMethod: .GET, url: "http://httpbin.org/delay/5", timeout: 3, execution: .sync).onNetworkError { (error) in
            XCTAssert(Date().timeIntervalSince(current) >= 3, "timeout test failed")
            }.responseJSON { (json, response) in
                XCTAssertEqual(json["url"].stringValue, "http://httpbin.org/delay/5")
        }
    }
}
