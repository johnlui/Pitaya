//
//  PitayaTests.swift
//  PitayaTests
//
//  Created by JohnLui on 15/7/24.
//  Copyright (c) 2015年 http://lvwenhan.com. All rights reserved.
//

import UIKit
import XCTest
import Pitaya

class AuthenticationTestCase: BaseTestCase {
    let user = "user"
    let password = "password"
    var URLString = ""
    
    override func setUp() {
        super.setUp()
        
        let credentialStorage = NSURLCredentialStorage.sharedCredentialStorage()
        let allCredentials = credentialStorage.allCredentials as [NSURLProtectionSpace: AnyObject]
        
        for (protectionSpace, credentials) in allCredentials {
            if let credentials = credentials as? [String: NSURLCredential] {
                for (_, credential) in credentials {
                    credentialStorage.removeCredential(credential, forProtectionSpace: protectionSpace)
                }
            }
        }
    }
}

class BasicAuthenticationTestCase: AuthenticationTestCase {
    override func setUp() {
        super.setUp()
        URLString = "http://httpbin.org/basic-auth/\(user)/\(password)"
    }
    
    func testHTTPBasicAuthenticationWithInvalidCredentials() {
        // Given
        let expectation = expectationWithDescription("\(URLString) 401")
        
        var res: NSHTTPURLResponse?
        
        // When
        let pitaya = PitayaManager.build(.GET, url: URLString)
        pitaya.fireWithBasicAuth(("invalid", "credentials"), errorCallback: { (error) -> Void in
            XCTAssert(false, error.localizedDescription)
            }) { (data, response) -> Void in
                res = response
                
                expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(defaultTimeout, handler: nil)
        XCTAssertEqual(res?.statusCode ?? 0, 401, "response status code should be 401")
    }
    
    func testHTTPBasicAuthenticationWithValidCredentials() {
        // Given
        let expectation = expectationWithDescription("\(URLString) 200")
        
        var res: NSHTTPURLResponse?
        
        // When
        let pitaya = PitayaManager.build(.GET, url: URLString)
        pitaya.fireWithBasicAuth((user, password), errorCallback: { (error) -> Void in
            XCTAssert(false, error.localizedDescription)
            }) { (data, response) -> Void in
                res = response
                
                expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
        XCTAssertEqual(res?.statusCode ?? 0, 200, "Basic Auth should get HTTP status 200")
    }
}
