Pitaya
--

Pitaya is a HTTP networking library written in Swift which tastes sweet.

![Pitaya logo](https://raw.githubusercontent.com/johnlui/Pitaya/master/Pitaya.png)

##Features

- [x] Fast file upload through "Content-Type: multipart/form-data"
- [x] All HTTP methods Supports
- [x] Multi-level API to keep your code clean
- [x] Well tested

##Requirements

* iOS 8.0+
* Xcode 6.3 (Swift 1.2)

##Installation

```bash
git clone https://github.com/johnlui/Pitaya
open Pitaya/Pitaya
```
then drag Pitaya.xcodeproj to your Project, that's it!

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