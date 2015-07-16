//
//  Pitaya.swift
//  Pitaya
//
//  Created by JohnLui on 15/5/14.
//  Copyright (c) 2015年 http://lvwenhan.com. All rights reserved.
//

import Foundation

extension String {
    var nsdata: NSData {
        return self.dataUsingEncoding(NSUTF8StringEncoding)!
    }
    var base64: String! {
        let utf8EncodeData: NSData! = self.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        let base64EncodingData = utf8EncodeData.base64EncodedStringWithOptions([])
        return base64EncodingData
    }
}

public func request(method: HTTPMethod, url: String, errorCallback: (error: NSError) -> Void, callback:(string: String) -> Void) {
    let pitaya = PitayaManager(url: url, method: method, errorCallback: errorCallback, callback: callback)
    pitaya.fire()
}
public func request(method: HTTPMethod, url: String, params: Dictionary<String, AnyObject>, errorCallback: (error: NSError) -> Void, callback:(string: String) -> Void) {
    let pitaya = PitayaManager(url: url, method: method, params: params, errorCallback: errorCallback, callback: callback)
    pitaya.fire()
}
public func request(method: HTTPMethod, url: String, files: Array<File>, errorCallback: (error: NSError) -> Void, callback:(string: String) -> Void) {
    let pitaya = PitayaManager(url: url, method: method, files: files, errorCallback: errorCallback, callback: callback)
    pitaya.fire()
}
public func request(method: HTTPMethod, url: String, params: Dictionary<String, AnyObject>, files: Array<File>, errorCallback: (error: NSError) -> Void, callback:(string: String) -> Void) {
    let pitaya = PitayaManager(url: url, method: method, params: params, files: files, errorCallback: errorCallback, callback: callback)
    pitaya.fire()
}

public enum HTTPMethod: String {
    case DELETE = "DELETE"
    case GET = "GET"
    case HEAD = "HEAD"
    case OPTIONS = "OPTIONS"
    case PATCH = "PATCH"
    case POST = "POST"
    case PUT = "PUT"
}
public struct File {
    let name: String!
    let url: NSURL!
    public init(name: String, url: NSURL) {
        self.name = name
        self.url = url
    }
}
public class PitayaManager {
    let boundary = "PitayaUGl0YXlh"
    let errorDomain = "com.lvwenhan.Pitaya"
    
    var HTTPBodyRaw = ""
    
    let method: String!
    var params: Dictionary<String, AnyObject>
    var files: Array<File>
    var errorCallback: ((error: NSError) -> Void)?
    var callback: ((string: String) -> Void)?
    
    let session = NSURLSession.sharedSession()
    let url: String!
    var request: NSMutableURLRequest!
    var task: NSURLSessionTask!
    
    // User-Agent Header; see http://tools.ietf.org/html/rfc7231#section-5.5.3
    let userAgent: String = {
        if let info = NSBundle.mainBundle().infoDictionary {
            let executable: AnyObject = info[kCFBundleExecutableKey as String] ?? "Unknown"
            let bundle: AnyObject = info[kCFBundleIdentifierKey as String] ?? "Unknown"
            let version: AnyObject = info[kCFBundleVersionKey as String] ?? "Unknown"
            let os: AnyObject = NSProcessInfo.processInfo().operatingSystemVersionString ?? "Unknown"
            
            var mutableUserAgent = NSMutableString(string: "\(executable)/\(bundle) (\(version); OS \(os))") as CFMutableString
            let transform = NSString(string: "Any-Latin; Latin-ASCII; [:^ASCII:] Remove") as CFString
            if CFStringTransform(mutableUserAgent, nil, transform, 0) == 1 {
                return mutableUserAgent as NSString as String
            }
        }
        
        return "Pitaya"
        }()
    
    init(url: String, method: HTTPMethod!, params: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>(), files: Array<File> = Array<File>(), errorCallback: ((error: NSError) -> Void)? = nil, callback: ((string: String) -> Void)? = nil) {
        self.url = url
        self.request = NSMutableURLRequest(URL: NSURL(string: url)!)
        self.method = method.rawValue
        self.params = params
        self.files = files
        self.errorCallback = errorCallback
        self.callback = callback
    }
    public static func build(method: HTTPMethod, url: String) -> PitayaManager {
        return PitayaManager(url: url, method: method)
    }
    public func addParams(params: Dictionary<String, AnyObject>) {
        self.params = params
    }
    public func addFiles(files: Array<File>) {
        self.files = files
    }
    public func setHTTPBodyRaw(rawString: String) {
        self.HTTPBodyRaw = rawString
    }
    public func fireWithBasicAuth(auth: (String, String), errorCallback: ((error: NSError) -> Void)? = nil, callback: ((string: String) -> Void)? = nil) {
        self.errorCallback = errorCallback
        self.callback = callback
        
        buildRequest()
        let authString = "Basic " + (auth.0 + ":" + auth.1).base64
        self.request.addValue(authString, forHTTPHeaderField: "Authorization")
        buildBody()
        fireTask()
    }
    public func fire(errorCallback: ((error: NSError) -> Void)? = nil, callback: ((string: String) -> Void)? = nil) {
        if let a = errorCallback {
            self.errorCallback = a
        }
        if let a = callback {
            self.callback = a
        }
        
        buildRequest()
        buildBody()
        fireTask()
    }
    func fireTask() {
        task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                let e = NSError(domain: self.errorDomain, code: error!.code, userInfo: error!.userInfo)
                NSLog(e.localizedDescription)
                dispatch_async(dispatch_get_main_queue()) {
                    self.errorCallback?(error: e)
                }
            } else {
                if let httpResponse = response as? NSHTTPURLResponse {
                    let code = httpResponse.statusCode
                    if code == 401 {
                        self.errorCallback?(error: NSError(domain: self.errorDomain, code: 401, userInfo: nil))
                    }
                    print("Pitaya HTTP Status: \(code) \(NSHTTPURLResponse.localizedStringForStatusCode(code))\n", appendNewline: false)
                }
                let string = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
                dispatch_async(dispatch_get_main_queue()) {
                    self.callback?(string: string)
                }
            }
        })
        task.resume()
    }
    func buildBody() {
        let data = NSMutableData()
        if self.HTTPBodyRaw != "" {
            data.appendData(self.HTTPBodyRaw.nsdata)
        } else if self.files.count > 0 {
            if self.method == "GET" {
                NSLog("\n\n------------------------\nThe remote server may not accept GET method with HTTP body. But Pitaya will send it anyway.\n------------------------\n\n")
            }
            for (key, value) in self.params {
                data.appendData("--\(self.boundary)\r\n".nsdata)
                data.appendData("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".nsdata)
                data.appendData("\(value.description)\r\n".nsdata)
            }
            for file in self.files {
                data.appendData("--\(self.boundary)\r\n".nsdata)
                data.appendData("Content-Disposition: form-data; name=\"\(file.name)\"; filename=\"\(file.url.description.lastPathComponent)\"\r\n\r\n".nsdata)
                if let a = NSData(contentsOfURL: file.url) {
                    data.appendData(a)
                    data.appendData("\r\n".nsdata)
                }
            }
            data.appendData("--\(self.boundary)--\r\n".nsdata)
        } else if self.params.count > 0 && self.method != "GET" {
            data.appendData(buildParams(self.params).nsdata)
        }
        request.HTTPBody = data
    }
    func buildRequest() {
        if self.method == "GET" && self.params.count > 0 {
            self.request = NSMutableURLRequest(URL: NSURL(string: url + "?" + buildParams(self.params))!)
        }
        
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        request.HTTPMethod = self.method
        
        // multipart Content-Type; see http://www.rfc-editor.org/rfc/rfc2046.txt
        if self.HTTPBodyRaw != "" {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        } else if self.files.count > 0 {
            request.addValue("multipart/form-data; boundary=" + self.boundary, forHTTPHeaderField: "Content-Type")
        } else if self.params.count > 0 {
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        }
        request.addValue(self.userAgent, forHTTPHeaderField: "User-Agent")
    }
    
    // stolen from Alamofire
    func buildParams(parameters: [String: AnyObject]) -> String {
        var components: [(String, String)] = []
        for key in Array(parameters.keys).sort(<) {
            let value: AnyObject! = parameters[key]
            components += self.queryComponents(key, value)
        }
        
        return "&".join(components.map{"\($0)=\($1)"} as [String])
    }
    func queryComponents(key: String, _ value: AnyObject) -> [(String, String)] {
        var components: [(String, String)] = []
        if let dictionary = value as? [String: AnyObject] {
            for (nestedKey, value) in dictionary {
                components += queryComponents("\(key)[\(nestedKey)]", value)
            }
        } else if let array = value as? [AnyObject] {
            for value in array {
                components += queryComponents("\(key)", value)
            }
        } else {
            components.extend([(escape(key), escape("\(value)"))])
        }
        
        return components
    }
    func escape(string: String) -> String {
        let legalURLCharactersToBeEscaped: CFStringRef = ":&=;+!@#$()',*"
        return CFURLCreateStringByAddingPercentEscapes(nil, string, nil, legalURLCharactersToBeEscaped, CFStringBuiltInEncodings.UTF8.rawValue) as String
    }
}
