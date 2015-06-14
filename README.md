Pitaya
--

![Carthage Compatibility](https://img.shields.io/badge/Carthage-✔-f2a77e.svg?style=flat)
![License](https://img.shields.io/cocoapods/l/Kingfisher.svg?style=flat)
![Platform](https://img.shields.io/cocoapods/p/Kingfisher.svg?style=flat)

Pitaya is a sweet HTTP networking library especially for large file uploads written in Swift. Inspired by [Alamofire](https://github.com/Alamofire/Alamofire) and [JustHTTP](https://github.com/JustHTTP/Just).

![Pitaya logo](https://raw.githubusercontent.com/johnlui/Pitaya/master/Pitaya.png)

##Features

- [x] Fast file upload through "Content-Type: multipart/form-data"
- [x] HTTP Basic Authorization supported
- [x] Asynchronous & Blocking(blocked in thread II)
- [x] Multi-level API to keep your code clean
- [x] Well tested

##Requirements

* iOS 8.0+
* Xcode 6.3 (Swift 1.2)

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
github "JohnLui/Pitaya" >= 0.1
```

Then fetch and build Pitaya:

```bash
carthage update
```

At last, add it to "Embedded Binaries" in the general panel use the "Add Other..." button. The Pitaya.framework binary file is lying in `./Carthage/Build/iOS` directory.


###Manually

```bash
git clone https://github.com/johnlui/Pitaya
open Pitaya/Pitaya
```
then drag Pitaya.xcodeproj to your Project, that's it!

##Usage

###Import


```swift
import Pitaya
```


####Make a request:

```swift
Pitaya.request(.GET, "http://pitayaswift.sinaapp.com/pitaya.php", { (error) -> Void in
    NSLog(error.localizedDescription)
    }) { (string) -> Void in
        println(string)
}
```

####with params:

```swift
Pitaya.request(.GET, "http://pitayaswift.sinaapp.com/pitaya.php", ["get": "pitaya"], { (error) -> Void in
    NSLog(error.localizedDescription)
    }) { (string) -> Void in
        println(string)
}
```

####upload files:

```swift
let file = File(name: "photo", url: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Info", ofType: "plist")!)!)
Pitaya.request(.POST, "http://pitayaswift.sinaapp.com/pitaya.php", files: [file], { (error) -> Void in
    NSLog(error.localizedDescription)
    }) { (string) -> Void in
        println(string)
}
```

####POST params and files:

```swift
let file = File(name: "photo", url: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Info", ofType: "plist")!)!)
Pitaya.request(.POST, "http://pitayaswift.sinaapp.com/pitaya.php", ["post": "pitaya", "post2": "pitaya2"], files: [file], { (error) -> Void in
    NSLog(error.localizedDescription)
    }) { (string) -> Void in
        println(string)
}
```

####HTTP Basic Authorization


```swift
let pitaya = PitayaManager.build(.GET, url: "http://httpbin.org/basic-auth/user/passwd")
pitaya.fireWithBasicAuth(("user", "passwd"), errorCallback: { (error) -> Void in
    NSLog(error.localizedDescription)
}) { (string) -> Void in
    println(string)
}
```

####Params and Files with HTTP Basic Authorization

```swift
let pitaya = PitayaManager.build(.GET, url: "http://httpbin.org/basic-auth/user/passwd")

// add params
pitaya.addParams(["hello": "pitaya"])

// add files
let file = File(name: "file", url: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Pitaya", ofType: "png")!)!)
pitaya.addFiles([file])

pitaya.fireWithBasicAuth(("user", "passwd"), errorCallback: { (error) -> Void in
    NSLog(error.localizedDescription)
}) { (string) -> Void in
    println(string)
}
```

###They are all Asynchronous.

##Play with JSON

You can use [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON) to parse string to JSON:


```swift
extension String {
    var nsdata: NSData {
        return self.dataUsingEncoding(NSUTF8StringEncoding)!
    }
}

Pitaya.request(.GET, "http://pitayaswift.sinaapp.com/pitaya.php", { (error) -> Void in
    NSLog(error.localizedDescription)
    }) { (string) -> Void in
        let json = JSON(data: string.nsdata)
        ... ...
}
```


##Contribution

You are welcome to fork and submit pull requests.

##License

Pitaya is open-sourced software licensed under the MIT license.
