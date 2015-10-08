//
//  Pitaya.swift
//  Pitaya
//
//  Created by JohnLui on 15/5/14.
//  Copyright (c) 2015年 http://lvwenhan.com. All rights reserved.
//

import Foundation

/// make your code looks tidier
public typealias Pita = Pitaya

public class Pitaya {
    
    /// if set to true, Pitaya will log all information in a NSURLSession lifecycle
    public static var DEBUG = false
    
    var method: HTTPMethod!
    var url: String!
    var params: [String: AnyObject]?
    var files: [File]?
    var errorCallback: ((error: NSError) -> Void)?
    var callback: ((data: NSData?, response: NSHTTPURLResponse?) -> Void)?
    
    /**
    add params to self (Pitaya object)
    
    - parameter params: what params you want to add in the request. Pitaya will do things right whether methed is GET or POST.
    
    - returns: self (Pitaya object)
    */
    public func addParams(params: [String: AnyObject]) -> Pitaya {
        self.params = params
        return self
    }
    
    /**
    add files to self (Pitaya object), POST only
    
    - parameter params: add some files to request
    
    - returns: self (Pitaya object)
    */
    public func addFiles(files: [File]) -> Pitaya {
        self.files = files
        return self
    }
    
    /**
    add error callback to self (Pitaya object).
    this will called only when network error, if we can receive any data from server, responseData() will be fired.
    
    - parameter errorCallback: errorCallback Closure
    
    - returns: self (Pitaya object)
    */
    public func onNetworkError(errorCallback: ((error: NSError) -> Void)) -> Pitaya {
        self.errorCallback = errorCallback
        return self
    }
    
    /**
    async response the http body in NSData type
    
    - parameter callback: callback Closure
    - parameter response: void
    */
    public func responseData(callback: ((data: NSData?, response: NSHTTPURLResponse?) -> Void)?) {
        let pm = PitayaManager(url: self.url, method: self.method, params: self.params, files: self.files, errorCallback: self.errorCallback, callback: callback)
        pm.fire()
    }
    
    /**
    async response the http body in String type
    
    - parameter callback: callback Closure
    - parameter response: void
    */
    public func responseString(callback: ((string: String?, response: NSHTTPURLResponse?) -> Void)?) {
        self.responseData { (data, response) -> Void in
            var string = ""
            if let d = data,
                s = NSString(data: d, encoding: NSUTF8StringEncoding) as? String {
                    string = s
            }
            callback?(string: string, response: response)
        }
    }
    
    public static func build(HTTPMethod method: HTTPMethod, url: String) -> Pitaya {
        let p = Pitaya()
        p.method = method
        p.url = url
        return p
    }
    
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

