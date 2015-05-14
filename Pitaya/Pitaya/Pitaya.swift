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
}

// stolen from JustHTTP which stolen from python-requests
let statusCodeDescriptions = [
    // Informational.
    100: "continue"                      , 101: "switching protocols"             , 102: "processing"                           ,
    103: "checkpoint"                    , 122: "uri too long"                    , 200: "ok"                                   ,
    201: "created"                       , 202: "accepted"                        , 203: "non authoritative info"               ,
    204: "no content"                    , 205: "reset content"                   , 206: "partial content"                      ,
    207: "multi status"                  , 208: "already reported"                , 226: "im used"                              ,
    
    // Redirection.
    300: "multiple choices"              , 301: "moved permanently"               , 302: "found"                                ,
    303: "see other"                     , 304: "not modified"                    , 305: "use proxy"                            ,
    306: "switch proxy"                  , 307: "temporary redirect"              , 308: "permanent redirect"                   ,
    
    // Client Error.
    400: "bad request"                   , 401: "unauthorized"                    , 402: "payment required"                     ,
    403: "forbidden"                     , 404: "not found"                       , 405: "method not allowed"                   ,
    406: "not acceptable"                , 407: "proxy authentication required"   , 408: "request timeout"                      ,
    409: "conflict"                      , 410: "gone"                            , 411: "length required"                      ,
    412: "precondition failed"           , 413: "request entity too large"        , 414: "request uri too large"                ,
    415: "unsupported media type"        , 416: "requested range not satisfiable" , 417: "expectation failed"                   ,
    418: "im a teapot"                   , 422: "unprocessable entity"            , 423: "locked"                               ,
    424: "failed dependency"             , 425: "unordered collection"            , 426: "upgrade required"                     ,
    428: "precondition required"         , 429: "too many requests"               , 431: "header fields too large"              ,
    444: "no response"                   , 449: "retry with"                      , 450: "blocked by windows parental controls" ,
    451: "unavailable for legal reasons" , 499: "client closed request"           ,
    
    // Server Error.
    500: "internal server error"         , 501: "not implemented"                 , 502: "bad gateway"                          ,
    503: "service unavailable"           , 504: "gateway timeout"                 , 505: "http version not supported"           ,
    506: "variant also negotiates"       , 507: "insufficient storage"            , 509: "bandwidth limit exceeded"             ,
    510: "not extended"
]

public func request(method: HTTPMethod, url: String, errorCallback: (error: NSError) -> Void, callback:(string: String) -> Void) {
    let pitaya = Pitaya(url: url, method: method, errorCallback: errorCallback, callback: callback)
    pitaya.fire()
}
public func request(method: HTTPMethod, url: String, params: Dictionary<String, AnyObject>, errorCallback: (error: NSError) -> Void, callback:(string: String) -> Void) {
    let pitaya = Pitaya(url: url, method: method, params: params, errorCallback: errorCallback, callback: callback)
    pitaya.fire()
}
public func request(method: HTTPMethod, url: String, params: Dictionary<String, AnyObject>, files: Array<File> = Array<File>(), errorCallback: (error: NSError) -> Void, callback:(string: String) -> Void) {
    let pitaya = Pitaya(url: url, method: method, params: params, files: files, errorCallback: errorCallback, callback: callback)
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
class Pitaya {
    let boundary = "PitayaUGl0YXlh"
    let errorDomain = "com.lvwenhan.Pitaya"
    
    let method: String!
    let params: Dictionary<String, AnyObject>
    let files: Array<File>
    let errorCallback: (error: NSError) -> Void
    let callback:(string: String) -> Void
    
    let session = NSURLSession.sharedSession()
    let url: String!
    var request: NSMutableURLRequest!
    var task: NSURLSessionTask!
    
    // User-Agent Header; see http://tools.ietf.org/html/rfc7231#section-5.5.3
    let userAgent: String = {
        if let info = NSBundle.mainBundle().infoDictionary {
            let executable: AnyObject = info[kCFBundleExecutableKey] ?? "Unknown"
            let bundle: AnyObject = info[kCFBundleIdentifierKey] ?? "Unknown"
            let version: AnyObject = info[kCFBundleVersionKey] ?? "Unknown"
            let os: AnyObject = NSProcessInfo.processInfo().operatingSystemVersionString ?? "Unknown"
            
            var mutableUserAgent = NSMutableString(string: "\(executable)/\(bundle) (\(version); OS \(os))") as CFMutableString
            let transform = NSString(string: "Any-Latin; Latin-ASCII; [:^ASCII:] Remove") as CFString
            if CFStringTransform(mutableUserAgent, nil, transform, 0) == 1 {
                return mutableUserAgent as NSString as! String
            }
        }
        
        return "Pitaya"
        }()
    
    init(url: String, method: HTTPMethod!, params: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>(), files: Array<File> = Array<File>(), errorCallback: (error: NSError) -> Void, callback:(String) -> Void) {
        self.url = url
        self.request = NSMutableURLRequest(URL: NSURL(string: url)!)
        self.method = method.rawValue
        self.params = params
        self.files = files
        self.errorCallback = errorCallback
        self.callback = callback
    }
    func fire() {
        buildRequest()
        buildBody()
        fireTask()
    }
    func fireTask() {
        task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                let e = NSError(domain: self.errorDomain, code: error.code, userInfo: error.userInfo)
                NSLog(e.localizedDescription)
                self.errorCallback(error: e)
            } else {
                if let httpResponse = response as? NSHTTPURLResponse {
                    let code = httpResponse.statusCode
                    println("Pitaya HTTP Status: \(code) \(statusCodeDescriptions[code]!)")
                }
                let string = NSString(data: data, encoding: NSUTF8StringEncoding) as! String
                self.callback(string: string)
            }
        })
        task.resume()
    }
    func buildBody() {
        if self.files.count > 0 {
            if self.method == "GET" {
                NSLog("\n\n------------------------\nThe remote server may not accept GET method with HTTP body. But Pitaya will send it anyway.\n------------------------\n\n")
            }
            let data = NSMutableData()
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
            request.HTTPBody = data
        } else if self.params.count > 0 && self.method != "GET" {
            request.HTTPBody = buildParams(self.params).nsdata
        }
    }
    func buildRequest() {
        if self.method == "GET" && self.params.count > 0 {
            self.request = NSMutableURLRequest(URL: NSURL(string: url + "?" + buildParams(self.params))!)
        }
        
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        request.HTTPMethod = self.method
        
        // multipart Content-Type; see http://www.rfc-editor.org/rfc/rfc2046.txt
        if self.files.count > 0 {
            request.addValue("multipart/form-data; boundary=" + self.boundary, forHTTPHeaderField: "Content-Type")
        } else if self.params.count > 0 {
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        }
        request.addValue("form-data", forHTTPHeaderField: "Content-Disposition")
        request.addValue(self.userAgent, forHTTPHeaderField: "User-Agent")
    }
    func buildParams(parameters: [String: AnyObject]) -> String {
        var components: [(String, String)] = []
        for key in sorted(Array(parameters.keys), <) {
            let value: AnyObject! = parameters[key]
            components += self.queryComponents(key, value)
        }
        
        return join("&", components.map{"\($0)=\($1)"} as [String])
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
