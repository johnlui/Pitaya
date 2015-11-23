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
//  Pitaya.swift
//  Pitaya
//
//  Created by JohnLui on 15/5/14.
//

import Foundation

/// make your code looks tidier
public typealias Pita = Pitaya

public class Pitaya {
    
    /// if set to true, Pitaya will log all information in a NSURLSession lifecycle
    public static var DEBUG = false
    
    var pitayaManager: PitayaManager!

    /**
    the only init method to fire a HTTP / HTTPS request
    
    - parameter method: the HTTP method you want
    - parameter url:    the url you want
    
    - returns: a Pitaya object
    */
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
    
    /**
    add a SSL pinning to check whether undering the Man-in-the-middle attack
    
    - parameter data:                     data of certification file, .cer format
    - parameter SSLValidateErrorCallBack: error callback closure
    
    - returns: self (Pitaya object)
    */
    public func addSSLPinning(LocalCertData data: NSData, SSLValidateErrorCallBack: (()->Void)? = nil) -> Pitaya {
        self.pitayaManager.addSSLPinning(LocalCertData: data, SSLValidateErrorCallBack: SSLValidateErrorCallBack)
        return self
    }
    
    /**
    set a custom HTTP header
    
    - parameter key:   HTTP header key
    - parameter value: HTTP header value
    
    - returns: self (Pitaya object)
    */
    public func setHTTPHeader(Name key: String, Value value: String) -> Pitaya {
        self.pitayaManager.setHTTPHeader(Name: key, Value: value)
        return self
    }

    /**
    set HTTP body to what you want. This method will discard any other HTTP body you have built.
    
    - parameter string: HTTP body string you want
    - parameter isJSON: is JSON or not: will set "Content-Type" of HTTP request to "application/json" or "text/plain;charset=UTF-8"
    
    - returns: self (Pitaya object)
    */
    public func setHTTPBodyRaw(string: String, isJSON: Bool = false) -> Pitaya {
        self.pitayaManager.sethttpBodyRaw(string, isJSON: isJSON)
        return self
    }
    
    /**
    set username and password of HTTP Basic Auth to the HTTP request header
    
    - parameter username: username
    - parameter password: password
    
    - returns: self (Pitaya object)
    */
    public func setBasicAuth(username: String, password: String) -> Pitaya {
        self.pitayaManager.setBasicAuth((username, password))
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
    
    /**
    async response the http body in JSON type use JSONNeverDie(https://github.com/johnlui/JSONNeverDie).
    
    - parameter callback: callback Closure
    - parameter response: void
    */
    public func responseJSON(callback: ((json: JSONND, response: NSHTTPURLResponse?) -> Void)?) {
        self.responseData { (data, response) -> Void in
            var json = JSONND()
            if let d = data {
                json = JSONND.initWithData(d)
            }
            callback?(json: json, response: response)
        }
    }
}