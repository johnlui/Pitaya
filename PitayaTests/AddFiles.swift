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
        let file = File(name: "file", url: self.URLForResource("logo@2x", withExtension: "jpg"))
        
        let expectation = self.expectation(description: "testAddOneFile")
        Pita.build(HTTPMethod: .POST, url: "http://tinylara.com:8000/pitaya.php")
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
    
    func testAddOneFileInData() {
        let data = try! Data(contentsOf: self.URLForResource("logo@2x", withExtension: "jpg"))
        let file = File(name: "file", data: data, type: "jpg")
        
        let expectation = self.expectation(description: "testAddOneFileInData")
        Pita.build(HTTPMethod: .POST, url: "http://tinylara.com:8000/pitaya.php")
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
        
        let file = File(name: "file", url: self.URLForResource("logo@2x", withExtension: "jpg"))
        
        let expectation = self.expectation(description: "testOneMoreThing")
        Pita.build(HTTPMethod: .GET, url: "http://tinylara.com:8000/pitaya.php")
            .addFiles([file])
            .onNetworkError({ (error) -> Void in
                XCTAssert(false, error.localizedDescription)
            })
            .responseData { (data, response) -> Void in
                expectation.fulfill()
        }
        
        waitForExpectations(timeout: self.defaultFileUploadTimeout, handler: nil)
    }
    
    func testOneMoreThingInData() {
        // code here will not be used in reality forever, just for increasing testing coverage
        
        let data = try! Data(contentsOf: self.URLForResource("logo@2x", withExtension: "jpg"))
        let file = File(name: "file", data: data, type: "jpg")
        
        let expectation = self.expectation(description: "testOneMoreThingInData")
        Pita.build(HTTPMethod: .GET, url: "http://tinylara.com:8000/pitaya.php")
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
