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
        let file = File(name: "file", url: self.URLForResource("logo", withExtension: "jpg"))
        
        let expectation = self.expectation(description: "testAddOneFile")
        Pita.build(HTTPMethod: .POST, url: "http://staticonsae.sinaapp.com/pitaya.php")
            .addParams(["param": "test"])
            .addFiles([file])
            .onNetworkError({ (error) -> Void in
                XCTAssert(false, error.localizedDescription)
            })
            .responseString({ (string, response) -> Void in
                XCTAssert(string == "1", "file uploaded error!")
                
                expectation.fulfill()
            })
        
        waitForExpectations(timeout: self.defaultFileUploadTimeout, handler: nil)
    }
    
    func testOneMoreThing() {
        // code here will not be used in reality forever, just for increasing testing coverage
        
        let file = File(name: "file", url: self.URLForResource("logo", withExtension: "jpg"))
        
        let expectation = self.expectation(description: "testOneMoreThing")
        Pita.build(HTTPMethod: .GET, url: "http://staticonsae.sinaapp.com/pitaya.php")
            .addFiles([file])
            .onNetworkError({ (error) -> Void in
                XCTAssert(false, error.localizedDescription)
            })
            .responseData { (data, response) -> Void in
                expectation.fulfill()
        }
        
        waitForExpectations(timeout: self.defaultFileUploadTimeout, handler: nil)
    }
}
