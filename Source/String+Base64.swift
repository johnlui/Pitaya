//
//  String+Base64.swift
//  Pitaya
//
//  Created by 吕文翰 on 15/10/7.
//  Copyright © 2015年 http://lvwenhan.com. All rights reserved.
//

import Foundation

extension String {
    var base64: String! {
        let utf8EncodeData: NSData! = self.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        let base64EncodingData = utf8EncodeData.base64EncodedStringWithOptions([])
        return base64EncodingData
    }
}