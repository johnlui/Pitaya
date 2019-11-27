// The MIT License (MIT)

// Copyright (c) 2015 JohnLui <wenhanlv@gmail.com> https://github.com/johnlui

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//
//  JSONND.swift
//  JSONNeverDie
//
//  Created by 吕文翰 on 15/10/7.
//

import Foundation

public struct JSONND {
    
    public static var debug = false
    
    public var data: Any!
    
    public init(string: String, encoding: String.Encoding = String.Encoding.utf8) {
        do {
            if let data = string.data(using: encoding) {
                let d = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                self.data = d as AnyObject?
            }
        } catch let error as NSError {
            let e = NSError(domain: "JSONNeverDie.JSONParseError", code: error.code, userInfo: error.userInfo)
            if JSONND.debug { NSLog(e.localizedDescription) }
        }
    }

    fileprivate init(any: AnyObject) {
        let j: JSONND = [any]
        self.data = j.arrayValue.first?.data
    }
    
    internal init(JSONdata: AnyObject!) {
        self.data = JSONdata
    }
    
    public init() {
        self.init(JSONdata: nil)
    }
    public init(dictionary: [String: Any]) {
        self.init(any: dictionary as AnyObject)
    }
    public init(array: [Any]) {
        self.init(any: array as AnyObject)
    }
    public subscript (index: String) -> JSONND {
        if let jsonDictionary = self.data as? Dictionary<String, AnyObject> {
            if let value = jsonDictionary[index] {
                return JSONND(JSONdata: value)
            } else {
                if JSONND.debug { NSLog("JSONNeverDie: No such key '\(index)'") }
            }
        }
        return JSONND(JSONdata: nil)
    }

    public var RAW: String? {
        get {
            if let _ = self.data {
                do {
                    let d = try JSONSerialization.data(withJSONObject: self.data, options: .prettyPrinted)
                    return NSString(data: d, encoding: String.Encoding.utf8.rawValue) as String?
                } catch { return nil }
                // can not test Errors here.
                // It seems that NSJSONSerialization.dataWithJSONObject() method dose not support do-try-catch in Swift 2 now.
            }
            return nil
        }
    }

    public var RAWValue: String {
        get {
            return self.RAW ?? ""
        }
    }
    public var int: Int? {
        get {
            if let number = self.data as? NSNumber {
                return number.intValue
            }
            if let number = self.data as? NSString {
                return number.integerValue
            }
            return nil
        }
    }
    public var intValue: Int {
        get {
            return self.int ?? 0
        }
    }
    public var double: Double? {
        get {
            if let number = self.data as? NSNumber {
                return number.doubleValue
            }
            if let number = self.data as? NSString {
                return number.doubleValue
            }
            return nil
        }
    }
    public var doubleValue: Double {
        get {
            return self.double ?? 0.0
        }
    }
    public var string: String? {
        get {
            return self.data as? String
        }
    }
    public var stringValue: String {
        get {
            return self.string ?? ""
        }
    }
    public var bool: Bool? {
        get {
            return self.data as? Bool
        }
    }
    public var boolValue: Bool {
        get {
            return self.bool ?? false
        }
    }
    public var array: [JSONND]? {
        get {
            if let _ = self.data {
                if let arr = self.data as? Array<AnyObject> {
                    var result = Array<JSONND>()
                    for i in arr {
                        result.append(JSONND(JSONdata: i))
                    }
                    return result
                }
                return nil
            }
            return nil
        }
    }
    public var arrayValue: [JSONND] {
        get {
            return self.array ?? [] 
        }
    }
}
