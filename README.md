#Pitaya ![Platform](https://img.shields.io/cocoapods/p/Kingfisher.svg?style=flat) ![License](https://img.shields.io/cocoapods/l/Kingfisher.svg?style=flat) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

Pitaya is a sweet HTTP networking library especially for large file uploads written in Swift. Inspired by [Alamofire](https://github.com/Alamofire/Alamofire) and [JustHTTP](https://github.com/JustHTTP/Just).

![Pitaya logo](https://raw.githubusercontent.com/johnlui/Pitaya/master/Pitaya.png)

##Features

- [x] Fast file upload through "Content-Type: multipart/form-data"
- [x] HTTP Basic Authorization supported
- [x] Asynchronous & Blocking(blocked in thread II)
- [x] Multi-level API to keep your code clean
- [x] Well tested
- [ ] Fully JSON support
- [ ] Asynchronous and synchronous support

##Requirements

* iOS 8.0+
* Xcode 6.4 (Swift 1.2) in [v0.2.3](https://github.com/johnlui/Pitaya/releases/tag/v0.2.3)
* Xcode 7 (Swift 2.0) after v0.3

##Installation

###Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that automates the process of adding frameworks to your Cocoa application.

You can install Carthage with Homebrew using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate Pitaya into your Xcode project using Carthage, specify it in your Cartfile:

```json
github "JohnLui/Pitaya"
```

Then fetch and build Pitaya:

```bash
carthage update
```

At last, add it to "Embedded Binaries" in the general panel use the "Add Other..." button. The Pitaya.framework binary file is lying in `./Carthage/Build/iOS` directory.


###Manually

```bash
git submodule add https://github.com/johnlui/Pitaya.git
open Pitaya/Pitaya
```
then drag Pitaya.xcodeproj to your Project, that's it!

If you want to run your project on device with Pitaya, just go to PROJECT->TARGETS->[your project name]->General->Embedded Binaries, click ＋, select Pitaya.frameWork and click "Add".

###Source File

Drag `Pitaya/Pitaya/Pitaya.swift` into your project.

##Usage

###Import
Only for sub-project using.

```swift
import Pitaya
```


####Make a request:

```swift
Pitaya.request(.GET, url: "http://pitayaswift.sinaapp.com/pitaya.php", errorCallback: { (error) -> Void in
    NSLog(error.localizedDescription)
    }) { (data, response) -> Void in
        let string = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
        print("HTTP body: " + string, appendNewline: true)
        print("HTTP status: " + response!.statusCode.description, appendNewline: true)
}
```

####with params:

```swift
Pitaya.request(.POST, url: "http://pitayaswift.sinaapp.com/pitaya.php", params: ["post": "pitaya"], errorCallback: { (error) -> Void in
    NSLog(error.localizedDescription)
    }) { (data, response) -> Void in
        let string = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
        print("HTTP body: " + string, appendNewline: true)
        print("HTTP status: " + response!.statusCode.description, appendNewline: true)
}
```

####upload files:

```swift
let file = File(name: "file", url: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Pitaya", ofType: "png")!))
Pitaya.request(.POST, url: "http://pitayaswift.sinaapp.com/pitaya.php", files: [file], errorCallback: { (error) -> Void in
    NSLog(error.localizedDescription)
    }) { (data, response) -> Void in
        let string = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
        print("HTTP body: " + string, appendNewline: true)
        print("HTTP status: " + response!.statusCode.description, appendNewline: true)
}
```

####POST params and files:

```swift
let file = File(name: "file", url: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Pitaya", ofType: "png")!))
Pitaya.request(.POST, url: "http://pitayaswift.sinaapp.com/pitaya.php", ["post": "pitaya", "post2": "pitaya2"], files: [file], errorCallback: { (error) -> Void in
    NSLog(error.localizedDescription)
    }) { (data, response) -> Void in
        let string = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
        print("HTTP body: " + string, appendNewline: true)
        print("HTTP status: " + response!.statusCode.description, appendNewline: true)
}
```

####RAW HTTP BODY

```swift
let pitaya = PitayaManager.build(.POST, url: "http://httpbin.org/post")
pitaya.setHTTPBodyRaw("{\"fuck\":\"you\"}")
pitaya.fire({ (error) -> Void in
    NSLog(error.localizedDescription)
    }) { (data, response) -> Void in
        let string = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
        print("HTTP body: " + string, appendNewline: true)
        print("HTTP status: " + response!.statusCode.description, appendNewline: true)
}
```

####HTTP Basic Authorization


```swift
let pitaya = PitayaManager.build(.GET, url: "http://httpbin.org/basic-auth/user/passwd")
pitaya.fireWithBasicAuth(("user", "passwd"), errorCallback: { (error) -> Void in
    NSLog(error.localizedDescription)
}) { (data, response) -> Void in
        let string = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
        print("HTTP body: " + string, appendNewline: true)
        print("HTTP status: " + response!.statusCode.description, appendNewline: true)
}
```

####Params and Files with HTTP Basic Authorization

```swift
let pitaya = PitayaManager.build(.GET, url: "http://httpbin.org/basic-auth/user/passwd")

// add params
pitaya.addParams(["hello": "pitaya"])

// add files
let file = File(name: "file", url: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Pitaya", ofType: "png")!))
pitaya.addFiles([file])

pitaya.fireWithBasicAuth(("user", "passwd"), errorCallback: { (error) -> Void in
    NSLog(error.localizedDescription)
}) { (data, response) -> Void in
        let string = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
        print("HTTP body: " + string, appendNewline: true)
        print("HTTP status: " + response!.statusCode.description, appendNewline: true)
}
```

###They are all Asynchronous.

##Play with JSON

You can use [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON) to parse string to JSON:


```swift
Pitaya.request(.GET, "http://pitayaswift.sinaapp.com/pitaya.php", { (error) -> Void in
    NSLog(error.localizedDescription)
    }) { (data, response) -> Void in
        let json = JSON(data: data)
        print(json["title"])
}
```


##Contribution

You are welcome to fork and submit pull requests.

##License

Pitaya is open-sourced software licensed under the MIT license.
