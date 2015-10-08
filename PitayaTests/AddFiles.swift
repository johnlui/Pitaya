//
//  AddFiles.swift
//  Pitaya
//
//  Created by 吕文翰 on 15/10/8.
//  Copyright © 2015年 http://lvwenhan.com. All rights reserved.
//

import XCTest
import Pitaya

class AddFiles: BaseTestCase {
    
    func testAddOneFile() {
        let file = File(name: "file", url: self.URLForResource("Pitaya", withExtension: "png"))
        
        let expectation = expectationWithDescription("testAddOneFile")
        Pita.build(HTTPMethod: .POST, url: "http://staticonsae.sinaapp.com/pitaya.php")
            .addFiles([file])
            .onNetworkError({ (error) -> Void in
                XCTAssert(false, error.localizedDescription)
            })
            .responseString({ (string, response) -> Void in
                XCTAssert(string == "1", "file uploaded error!")
                
                expectation.fulfill()
            })
        
        waitForExpectationsWithTimeout(self.defaultTimeout, handler: nil)
    }
}
