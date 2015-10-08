//
//  PitayaManager.swift
//  Pitaya
//
//  Created by 吕文翰 on 15/10/7.
//  Copyright © 2015年 http://lvwenhan.com. All rights reserved.
//

import Foundation

public class PitayaManager: NSObject, NSURLSessionDelegate {
    let boundary = "PitayaUGl0YXlh"
    let errorDomain = "com.lvwenhan.Pitaya"
    
    var HTTPBodyRaw = ""
    
    let method: String!
    var params: [String: AnyObject]?
    var files: [File]?
    var errorCallback: ((error: NSError) -> Void)?
    var callback: ((data: NSData?, response: NSHTTPURLResponse?) -> Void)?
    
    var session: NSURLSession!
    let url: String!
    var request: NSMutableURLRequest!
    var task: NSURLSessionTask!
    
    var localCertData: NSData!
    var sSLValidateErrorCallBack: (() -> Void)?
    
    // User-Agent Header; see http://tools.ietf.org/html/rfc7231#section-5.5.3
    let userAgent: String = {
        if let info = NSBundle.mainBundle().infoDictionary {
            let executable: AnyObject = info[kCFBundleExecutableKey as String] ?? "Unknown"
            let bundle: AnyObject = info[kCFBundleIdentifierKey as String] ?? "Unknown"
            let version: AnyObject = info[kCFBundleVersionKey as String] ?? "Unknown"
            let os: AnyObject = NSProcessInfo.processInfo().operatingSystemVersionString ?? "Unknown"
            
            var mutableUserAgent = NSMutableString(string: "\(executable)/\(bundle) (\(version); OS \(os))") as CFMutableString
            let transform = NSString(string: "Any-Latin; Latin-ASCII; [:^ASCII:] Remove") as CFString
            if CFStringTransform(mutableUserAgent, nil, transform, false) {
                return mutableUserAgent as NSString as String
            }
        }
        
        return "Pitaya"
        }()
    
    public static func build(method: HTTPMethod, url: String) -> PitayaManager {
        return PitayaManager(url: url, method: method)
    }

    private init(url: String, method: HTTPMethod!) {
        self.url = url
        self.request = NSMutableURLRequest(URL: NSURL(string: url)!)
        self.method = method.rawValue
        
        super.init()
        self.session = NSURLSession(configuration: NSURLSession.sharedSession().configuration, delegate: self, delegateQueue: NSURLSession.sharedSession().delegateQueue)
    }
    public func addSSLPinning(LocalCertData data: NSData, SSLValidateErrorCallBack: (()->Void)? = nil) {
        self.localCertData = data
        self.sSLValidateErrorCallBack = SSLValidateErrorCallBack
    }
    public func addParams(params: [String: AnyObject]?) {
        self.params = params
    }
    public func addFiles(files: [File]?) {
        self.files = files
    }
    public func addErrorCallback(errorCallback: ((error: NSError) -> Void)?) {
        self.errorCallback = errorCallback
    }
    public func addHTTPBodyRaw(rawString: String) {
        self.HTTPBodyRaw = rawString
    }
    public func fireWithBasicAuth(auth: (String, String), callback: ((data: NSData?, response: NSHTTPURLResponse?) -> Void)? = nil) {
        self.callback = callback
        
        buildRequest()
        let authString = "Basic " + (auth.0 + ":" + auth.1).base64
        self.request.addValue(authString, forHTTPHeaderField: "Authorization")
        buildBody()
        fireTask()
    }
    public func fire(callback: ((data: NSData?, response: NSHTTPURLResponse?) -> Void)? = nil) {
        if let _ = callback {
            self.callback = callback
        }
        
        buildRequest()
        buildBody()
        fireTask()
    }
    private func fireTask() {
        if Pitaya.DEBUG { if let a = request.allHTTPHeaderFields { NSLog("Pitaya Request HEADERS: " + a.description) } }
        task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if Pitaya.DEBUG { if let a = response { NSLog("Pitaya Response: " + a.description) } }
            if error != nil {
                let e = NSError(domain: self.errorDomain, code: error!.code, userInfo: error!.userInfo)
                NSLog("Pitaya Error: " + e.localizedDescription)
                dispatch_async(dispatch_get_main_queue()) {
                    self.errorCallback?(error: e)
                }
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    self.callback?(data: data, response: response as? NSHTTPURLResponse)
                }
            }
        })
        task.resume()
    }
    private func buildBody() {
        let data = NSMutableData()
        if self.HTTPBodyRaw != "" {
            data.appendData(self.HTTPBodyRaw.nsdata)
        } else if self.files?.count > 0 {
            if self.method == "GET" {
                NSLog("\n\n------------------------\nThe remote server may not accept GET method with HTTP body. But Pitaya will send it anyway.\n------------------------\n\n")
            }
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
        } else if self.params?.count > 0 && self.method != "GET" {
            data.appendData(Helper.buildParams(self.params!).nsdata)
        }
        request.HTTPBody = data
    }
    private func buildRequest() {
        if self.method == "GET" && self.params?.count > 0 {
            self.request = NSMutableURLRequest(URL: NSURL(string: url + "?" + Helper.buildParams(self.params!))!)
        }
        
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        request.HTTPMethod = self.method
        
        // multipart Content-Type; see http://www.rfc-editor.org/rfc/rfc2046.txt
        if self.HTTPBodyRaw != "" {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        } else if self.files?.count > 0 {
            request.addValue("multipart/form-data; boundary=" + self.boundary, forHTTPHeaderField: "Content-Type")
        } else if self.params?.count > 0 {
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        }
        request.addValue(self.userAgent, forHTTPHeaderField: "User-Agent")
    }
}
