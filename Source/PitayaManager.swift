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
//  PitayaManager.swift
//  Pitaya
//
//  Created by 吕文翰 on 15/10/7.
//

import Foundation

class PitayaManager: NSObject, NSURLSessionDelegate {
    let boundary = "PitayaUGl0YXlh"
    let errorDomain = "com.lvwenhan.Pitaya"
    
    var HTTPBodyRaw = ""
    var HTTPBodyRawIsJSON = false
    
    let method: String!
    var params: [String: AnyObject]?
    var files: [File]?
    var errorCallback: ((error: NSError) -> Void)?
    var callback: ((data: NSData?, response: NSHTTPURLResponse?) -> Void)?
    
    var session: NSURLSession!
    let url: String!
    var request: NSMutableURLRequest!
    var task: NSURLSessionTask!
    var basicAuth: (String, String)!
    
    var localCertData: NSData!
    var sSLValidateErrorCallBack: (() -> Void)?
    
    var extraHTTPHeaders = [(String, String)]()
    
    // User-Agent Header; see http://tools.ietf.org/html/rfc7231#section-5.5.3
    let userAgent: String = {
        if let info = NSBundle.mainBundle().infoDictionary {
            let executable: AnyObject = info[kCFBundleExecutableKey as String] ?? "Unknown"
            let bundle: AnyObject = info[kCFBundleIdentifierKey as String] ?? "Unknown"
            let version: AnyObject = info[kCFBundleVersionKey as String] ?? "Unknown"
            // could not tested
            let os: AnyObject = NSProcessInfo.processInfo().operatingSystemVersionString ?? "Unknown"
            
            var mutableUserAgent = NSMutableString(string: "\(executable)/\(bundle) (\(version); OS \(os))") as CFMutableString
            let transform = NSString(string: "Any-Latin; Latin-ASCII; [:^ASCII:] Remove") as CFString
            if CFStringTransform(mutableUserAgent, nil, transform, false) {
                return mutableUserAgent as NSString as String
            }
        }
        
        // could not tested
        return "Pitaya"
        }()

    init(url: String, method: HTTPMethod!) {
        self.url = url
        self.request = NSMutableURLRequest(URL: NSURL(string: url)!)
        self.method = method.rawValue
        
        super.init()
        // setup a session with delegate to self
        self.session = NSURLSession(configuration: NSURLSession.sharedSession().configuration, delegate: self, delegateQueue: NSURLSession.sharedSession().delegateQueue)
    }
    func addSSLPinning(LocalCertData data: NSData, SSLValidateErrorCallBack: (()->Void)? = nil) {
        self.localCertData = data
        self.sSLValidateErrorCallBack = SSLValidateErrorCallBack
    }
    func addParams(params: [String: AnyObject]?) {
        self.params = params
    }
    func addFiles(files: [File]?) {
        self.files = files
    }
    func addErrorCallback(errorCallback: ((error: NSError) -> Void)?) {
        self.errorCallback = errorCallback
    }
    func setHTTPHeader(Name key: String, Value value: String) {
        self.extraHTTPHeaders.append((key, value))
    }
    func sethttpBodyRaw(rawString: String, isJSON: Bool = false) {
        self.HTTPBodyRaw = rawString
        self.HTTPBodyRawIsJSON = isJSON
    }
    func setBasicAuth(auth: (String, String)) {
        self.basicAuth = auth
    }
    func fire(callback: ((data: NSData?, response: NSHTTPURLResponse?) -> Void)? = nil) {
        self.callback = callback
        
        self.buildRequest()
        self.buildHeader()
        self.buildBody()
        self.fireTask()
    }
    private func buildRequest() {
        if self.method == "GET" && self.params?.count > 0 {
            self.request = NSMutableURLRequest(URL: NSURL(string: url + "?" + Helper.buildParams(self.params!))!)
        }
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        request.HTTPMethod = self.method
    }
    private func buildHeader() {
        // multipart Content-Type; see http://www.rfc-editor.org/rfc/rfc2046.txt
        if self.params?.count > 0 {
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        }
        if self.files?.count > 0 && self.method != "GET" {
            request.setValue("multipart/form-data; boundary=" + self.boundary, forHTTPHeaderField: "Content-Type")
        }
        if self.HTTPBodyRaw != "" {
            request.setValue(self.HTTPBodyRawIsJSON ? "application/json" : "text/plain;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        }
        request.addValue(self.userAgent, forHTTPHeaderField: "User-Agent")
        if let auth = self.basicAuth {
            let authString = "Basic " + (auth.0 + ":" + auth.1).base64
            request.addValue(authString, forHTTPHeaderField: "Authorization")
        }
        for i in self.extraHTTPHeaders {
            request.setValue(i.1, forHTTPHeaderField: i.0)
        }
    }
    private func buildBody() {
        let data = NSMutableData()
        if self.HTTPBodyRaw != "" {
            data.appendData(self.HTTPBodyRaw.nsdata)
        } else if self.files?.count > 0 {
            if self.method == "GET" {
                NSLog("\n\n------------------------\nThe remote server may not accept GET method with HTTP body. But Pitaya will send it anyway.\nBut it looks like iOS 9 SDK has prevented sending http body in GET method.\n------------------------\n\n")
            } else {
                if let ps = self.params {
                    for (key, value) in ps {
                        data.appendData("--\(self.boundary)\r\n".nsdata)
                        data.appendData("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".nsdata)
                        data.appendData("\(value.description)\r\n".nsdata)
                    }
                }
                if let fs = self.files {
                    for file in fs {
                        data.appendData("--\(self.boundary)\r\n".nsdata)
                        data.appendData("Content-Disposition: form-data; name=\"\(file.name)\"; filename=\"\(NSString(string: file.url.description).lastPathComponent)\"\r\n\r\n".nsdata)
                        if let a = NSData(contentsOfURL: file.url) {
                            data.appendData(a)
                            data.appendData("\r\n".nsdata)
                        }
                    }
                }
                data.appendData("--\(self.boundary)--\r\n".nsdata)
            }
        } else if self.params?.count > 0 && self.method != "GET" {
            data.appendData(Helper.buildParams(self.params!).nsdata)
        }
        request.HTTPBody = data
    }
    private func fireTask() {
        if Pitaya.DEBUG { if let a = request.allHTTPHeaderFields { NSLog("Pitaya Request HEADERS: ", a.description); }; }
        task = session.dataTaskWithRequest(request, completionHandler: { [weak self] (data, response, error) -> Void in
            if Pitaya.DEBUG { if let a = response { NSLog("Pitaya Response: ", a.description); }}
            if error != nil {
                let e = NSError(domain: self?.errorDomain ?? "Pitaya", code: error!.code, userInfo: error!.userInfo)
                NSLog("Pitaya Error: ", e.localizedDescription)
                dispatch_async(dispatch_get_main_queue()) {
                    self?.errorCallback?(error: e)
                    self?.session.finishTasksAndInvalidate()
                }
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    self?.callback?(data: data, response: response as? NSHTTPURLResponse)
                    self?.session.finishTasksAndInvalidate()
                }
            }
        })
        task.resume()
    }
}
