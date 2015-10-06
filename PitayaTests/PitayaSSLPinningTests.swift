//
//  PitayaSSLPinningTests.swift
//  Pitaya
//
//  Created by 吕文翰 on 15/10/6.
//  Copyright © 2015年 http://lvwenhan.com. All rights reserved.
//

import XCTest
import Pitaya

class PitayaSSLPinningTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSSLPining() {
        let certData = NSData(contentsOfFile: NSBundle(forClass: PitayaTests.self).pathForResource("lvwenhancom", ofType: "cer")!)!
        
        let request = PitayaManager.build(.GET, url: "https://lvwenhan.com/")
        request.addSSLPinning(LocalCertData: certData, SSLValidateErrorCallBack: { () -> Void in
            XCTFail("Under the Man-in-the-middle attack!")
        })
        request.fire({ (error) -> Void in
            print(error)
            }) { (data, response) -> Void in
                let string = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
                XCTAssert(string.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0)
        }
        
        let request2 = PitayaManager.build(.GET, url: "https://www.baidu.com/")
        var errorPinning = 0
        request2.addSSLPinning(LocalCertData: certData, SSLValidateErrorCallBack: { () -> Void in
            print("Under the Man-in-the-middle attack!")
            errorPinning = 1
        })
        request2.fire({ (error) -> Void in
            XCTAssertNotNil(error)
            XCTAssert(errorPinning == 1, "Under the Man-in-the-middle attack")
            }) { (data, response) -> Void in
                XCTFail("shoud not run callback() after a Man-in-the-middle attack.")
        }
    }
    
}
