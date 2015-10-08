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
    
    var pitayaManager: PitayaManager!
    
    var localCertData: NSData!
    var sSLValidateErrorCallBack: (() -> Void)?
    
    public static func build(HTTPMethod method: HTTPMethod, url: String) -> Pitaya {
        let p = Pitaya()
        p.pitayaManager = PitayaManager.build(method, url: url)
        return p
    }

    /**
    add params to self (Pitaya object)
    
    - parameter params: what params you want to add in the request. Pitaya will do things right whether methed is GET or POST.
    
    - returns: self (Pitaya object)
    */
    public func addParams(params: [String: AnyObject]) -> Pitaya {
        self.pitayaManager.addParams(params)
        return self
    }
    
    /**
    add files to self (Pitaya object), POST only
    
    - parameter params: add some files to request
    
    - returns: self (Pitaya object)
    */
    public func addFiles(files: [File]) -> Pitaya {
        self.pitayaManager.addFiles(files)
        return self
    }
    
    public func addSSLPinning(LocalCertData data: NSData, SSLValidateErrorCallBack: (()->Void)? = nil) -> Pitaya {
        self.pitayaManager.addSSLPinning(LocalCertData: data, SSLValidateErrorCallBack: SSLValidateErrorCallBack)
        return self
    }
    
    /**
    add error callback to self (Pitaya object).
    this will called only when network error, if we can receive any data from server, responseData() will be fired.
    
    - parameter errorCallback: errorCallback Closure
    
    - returns: self (Pitaya object)
    */
    public func onNetworkError(errorCallback: ((error: NSError) -> Void)) -> Pitaya {
        self.pitayaManager.addErrorCallback(errorCallback)
        return self
    }
    
    /**
    async response the http body in NSData type
    
    - parameter callback: callback Closure
    - parameter response: void
    */
    public func responseData(callback: ((data: NSData?, response: NSHTTPURLResponse?) -> Void)?) {
        self.pitayaManager?.fire(callback)
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
    
    public func responseDataWithBasicAuth(username username: String, password: String, callback: ((data: NSData?, response: NSHTTPURLResponse?) -> Void)?) {
        self.pitayaManager?.fireWithBasicAuth((username, password), callback: callback)
    }
    
    public func responseStringWithBasicAuth(username username: String, password: String, callback: ((string: String?, response: NSHTTPURLResponse?) -> Void)?) {
        self.responseDataWithBasicAuth(username: username, password: password) { (data, response) -> Void in
            var string = ""
            if let d = data,
                s = NSString(data: d, encoding: NSUTF8StringEncoding) as? String {
                    string = s
            }
            callback?(string: string, response: response)
        }
    }
}