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
    
    public var data: AnyObject!
    public static func initWithData(data: NSData) -> JSONND! {
        do {
            return JSONND(data: try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments))
        } catch let error as NSError {
            let e = NSError(domain: "JSONNeverDie.JSONParseError", code: error.code, userInfo: error.userInfo)
            if JSONND.debug { NSLog(e.localizedDescription); }
            return JSONND(data: nil)
        }
    }
    private init(any: AnyObject) {
        let j: JSONND = [any]
        self.data = j.arrayValue.first != nil ? j.arrayValue.first!.data : nil
    }
    init(data: AnyObject!) {
        self.data = data
    }
    public init() {
        self.init(data: nil)
    }
    public init(dictionary: [String: AnyObject]) {
        self.init(any: dictionary)
    }
    public init(array: [AnyObject]) {
        self.init(any: array)
    }
    public subscript (index: String) -> JSONND {
        if let jsonDictionary = self.data as? Dictionary<String, AnyObject> {
            if let value = jsonDictionary[index] {
                return JSONND(data: value)
            } else {
                if JSONND.debug { NSLog("JSONNeverDie: No such key '\(index)'"); }
            }
        }
        return JSONND(data: nil)
    }
    
    @available (*, unavailable, renamed="RAW")
    public var jsonString: String? {
        return ""
    }
    public var RAW: String? {
        get {
            do {
                if let _ = self.data {
                    let d = try NSJSONSerialization.dataWithJSONObject(self.data, options: .PrettyPrinted)
                    return NSString(data: d, encoding: NSUTF8StringEncoding) as? String
                }
                return nil
            } catch {
                // can not test Errors here.
                // It seems that NSJSONSerialization.dataWithJSONObject() method dose not support do-try-catch in Swift 2 now.
                return nil
            }
        }
    }
    @available (*, unavailable, renamed="RAWValue")
    public var jsonStringValue: String {
        return ""
    }
    public var RAWValue: String {
        get {
            return self.RAW ?? ""
        }
    }
    public var int: Int? {
        get {
            return self.data?.integerValue
        }
    }
    public var intValue: Int {
        get {
            return self.int ?? 0
        }
    }
    public var float: Float? {
        get {
            return self.data?.floatValue
        }
    }
    public var floatValue: Float {
        get {
            return self.float ?? 0.0
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
                        result.append(JSONND(data: i))
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
