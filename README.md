Pitaya
--

Pitaya is a HTTP networking library written in Swift which tastes sweet.

![Pitaya logo](http://lvwenhan.com/content/uploadfile/201505/d1591431607600.png)

##Features

- [x] Fast file upload through "Content-Type: multipart/form-data"
- [x] Support all HTTP methods
- [x] Multi-level API to keep your code clean

##Requirements

* iOS 8.0+
* Xcode 6.3 (Swift 1.2)

##Installation

You can only install Pitaya manually now, just like: https://github.com/Alamofire/Alamofire#manually

##Usage

Make a request:

```swift
Pitaya.request(.GET, "http://pitayaswift.sinaapp.com/pitaya.php", { (error) -> Void in
    NSLog(error.localizedDescription)
    }) { (string) -> Void in
        println(string)
}
```

with params:

```swift
Pitaya.request(.GET, "http://pitayaswift.sinaapp.com/pitaya.php", ["get": "pitaya"], { (error) -> Void in
    NSLog(error.localizedDescription)
    }) { (string) -> Void in
        println(string)
}
```

upload a file:

```swift
let file = File(name: "photo", url: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Info", ofType: "plist")!)!)
Pitaya.request(.POST, "http://pitayaswift.sinaapp.com/pitaya.php", ["post": "pitaya", "post2": "pitaya2"], files: [file], { () -> Void in
    println("Error")
    }) { (string) -> Void in
        println(string)
}
```

##Contribution

You are welcome to fork and submit pull requests.

##License

Pitaya is open-sourced software licensed under the MIT license.