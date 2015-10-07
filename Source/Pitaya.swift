//
//  Pitaya.swift
//  Pitaya
//
//  Created by JohnLui on 15/5/14.
//  Copyright (c) 2015年 http://lvwenhan.com. All rights reserved.
//

import Foundation

public class Pitaya {
    
    public static var DEBUG = false
    
    public static func request(method: HTTPMethod, url: String, errorCallback: ((error: NSError) -> Void)?, callback: ((data: NSData?, response: NSHTTPURLResponse?) -> Void)?) {
        let pitaya = PitayaManager(url: url, method: method, errorCallback: errorCallback, callback: callback)
        pitaya.fire()
    }
    public static func request(method: HTTPMethod, url: String, params: Dictionary<String, AnyObject>, errorCallback: ((error: NSError) -> Void)?, callback: ((data: NSData?, response: NSHTTPURLResponse?) -> Void)? ) {
        let pitaya = PitayaManager(url: url, method: method, params: params, errorCallback: errorCallback, callback: callback)
        pitaya.fire()
    }
    public static func request(method: HTTPMethod, url: String, files: Array<File>, errorCallback: ((error: NSError) -> Void)?, callback: ((data: NSData?, response: NSHTTPURLResponse?) -> Void)?) {
        let pitaya = PitayaManager(url: url, method: method, files: files, errorCallback: errorCallback, callback: callback)
        pitaya.fire()
    }
    public static func request(method: HTTPMethod, url: String, params: Dictionary<String, AnyObject>, files: Array<File>, errorCallback: ((error: NSError) -> Void)?, callback:((data: NSData?, response: NSHTTPURLResponse?) -> Void)? ) {
        let pitaya = PitayaManager(url: url, method: method, params: params, files: files, errorCallback: errorCallback, callback: callback)
        pitaya.fire()
    }
}

