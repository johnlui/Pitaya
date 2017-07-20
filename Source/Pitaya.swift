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

open class Pitaya {
    
    /// if set to true, Pitaya will log all information in a NSURLSession lifecycle
    open static var DEBUG = false
    
    var pitayaManager: PitayaManager!

    /**
    the only init method to fire a HTTP / HTTPS request
    
    - parameter method:     the HTTP method you want
    - parameter url:        the url you want
    - parameter timeout:    time out setting
    
    - returns: a Pitaya object
    */
    open static func build(HTTPMethod method: HTTPMethod, url: String) -> Pitaya {
        let p = Pitaya()
        p.pitayaManager = PitayaManager.build(method, url: url)
        return p
    }
    open static func build(HTTPMethod method: HTTPMethod, url: String, timeout: Double, execution: Execution = .async) -> Pitaya {
        let p = Pitaya()
        p.pitayaManager = PitayaManager.build(method, url: url, timeout: timeout, execution: execution)
        return p
    }
    
    /**
    add params to self (Pitaya object)
    
    - parameter params: what params you want to add in the request. Pitaya will do things right whether methed is GET or POST.
    
    - returns: self (Pitaya object)
    */
    open func addParams(_ params: [String: Any]) -> Pitaya {
        self.pitayaManager.addParams(params)
        return self
    }
    
    /**
    add files to self (Pitaya object), POST only
    
    - parameter params: add some files to request
    
    - returns: self (Pitaya object)
    */
    open func addFiles(_ files: [File]) -> Pitaya {
        self.pitayaManager.addFiles(files)
        return self
    }
    
    /**
    add a SSL pinning to check whether undering the Man-in-the-middle attack
    
    - parameter data:                     data of certification file, .cer format
    - parameter SSLValidateErrorCallBack: error callback closure
    
    - returns: self (Pitaya object)
    */
    open func addSSLPinning(LocalCertData data: Data, SSLValidateErrorCallBack: (()->Void)? = nil) -> Pitaya {
        self.pitayaManager.addSSLPinning(LocalCertData: [data], SSLValidateErrorCallBack: SSLValidateErrorCallBack)
        return self
    }
    
    /**
     add a SSL pinning to check whether undering the Man-in-the-middle attack
     
     - parameter LocalCertDataArray:       data array of certification file, .cer format
     - parameter SSLValidateErrorCallBack: error callback closure
     
     - returns: self (Pitaya object)
     */
    open func addSSLPinning(LocalCertDataArray dataArray: [Data], SSLValidateErrorCallBack: (()->Void)? = nil) -> Pitaya {
        self.pitayaManager.addSSLPinning(LocalCertData: dataArray, SSLValidateErrorCallBack: SSLValidateErrorCallBack)
        return self
    }
    
    /**
    set a custom HTTP header
    
    - parameter key:   HTTP header key
    - parameter value: HTTP header value
    
    - returns: self (Pitaya object)
    */
    open func setHTTPHeader(Name key: String, Value value: String) -> Pitaya {
        self.pitayaManager.setHTTPHeader(Name: key, Value: value)
        return self
    }

    /**
    set HTTP body to what you want. This method will discard any other HTTP body you have built.
    
    - parameter string: HTTP body string you want
    - parameter isJSON: is JSON or not: will set "Content-Type" of HTTP request to "application/json" or "text/plain;charset=UTF-8"
    
    - returns: self (Pitaya object)
    */
    open func setHTTPBodyRaw(_ string: String, isJSON: Bool = false) -> Pitaya {
        self.pitayaManager.sethttpBodyRaw(string, isJSON: isJSON)
        return self
    }
    
    /**
    set username and password of HTTP Basic Auth to the HTTP request header
    
    - parameter username: username
    - parameter password: password
    
    - returns: self (Pitaya object)
    */
    open func setBasicAuth(_ username: String, password: String) -> Pitaya {
        self.pitayaManager.setBasicAuth((username, password))
        return self
    }
    
    /**
    add error callback to self (Pitaya object).
    this will called only when network error, if we can receive any data from server, responseData() will be fired.
    
    - parameter errorCallback: errorCallback Closure
    
    - returns: self (Pitaya object)
    */
    open func onNetworkError(_ errorCallback: @escaping ((_ error: NSError) -> Void)) -> Pitaya {
        self.pitayaManager.addErrorCallback(errorCallback)
        return self
    }
    
    /**
    async response the http body in NSData type
    
    - parameter callback: callback Closure
    - parameter response: void
    */
    open func responseData(_ callback: ((_ data: Data?, _ response: HTTPURLResponse?) -> Void)?) {
        self.pitayaManager?.fire(callback)
    }
    
    /**
    async response the http body in String type
    
    - parameter callback: callback Closure
    - parameter response: void
    */
    open func responseString(_ callback: ((_ string: String?, _ response: HTTPURLResponse?) -> Void)?) {
        self.responseData { (data, response) -> Void in
            var string = ""
            if let d = data,
                let s = NSString(data: d, encoding: String.Encoding.utf8.rawValue) as String? {
                    string = s
            }
            callback?(string, response)
        }
    }
    
    /**
    async response the http body in JSON type use JSONNeverDie(https://github.com/johnlui/JSONNeverDie).
    
    - parameter callback: callback Closure
    - parameter response: void
    */
    open func responseJSON(_ callback: ((_ json: JSONND, _ response: HTTPURLResponse?) -> Void)?) {
        self.responseString { (string, response) in
            var json = JSONND()
            if let s = string {
                json = JSONND(string: s)
            }
            callback?(json, response)
        }
    }
    
    /**
    cancel the request.
     
     - parameter callback: callback Closure
     */
    open func cancel(_ callback: (() -> Void)?) {
        self.pitayaManager.cancelCallback = callback
        self.pitayaManager.task.cancel()
    }
}
