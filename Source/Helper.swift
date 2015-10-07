//
//  Helper.swift
//  Pitaya
//
//  Created by 吕文翰 on 15/10/7.
//  Copyright © 2015年 http://lvwenhan.com. All rights reserved.
//

import Foundation

class Helper {
    // stolen from Alamofire
    static func queryComponents(key: String, _ value: AnyObject) -> [(String, String)] {
        var components: [(String, String)] = []
        if let dictionary = value as? [String: AnyObject] {
            for (nestedKey, value) in dictionary {
                components += Helper.queryComponents("\(key)[\(nestedKey)]", value)
            }
        } else if let array = value as? [AnyObject] {
            for value in array {
                components += Helper.queryComponents("\(key)", value)
            }
        } else {
            components.appendContentsOf([(Helper.escape(key), Helper.escape("\(value)"))])
        }
        
        return components
    }
    // stolen from Alamofire
    static func escape(string: String) -> String {
        let legalURLCharactersToBeEscaped: CFStringRef = ":&=;+!@#$()',*"
        return CFURLCreateStringByAddingPercentEscapes(nil, string, nil, legalURLCharactersToBeEscaped, CFStringBuiltInEncodings.UTF8.rawValue) as String
    }
}