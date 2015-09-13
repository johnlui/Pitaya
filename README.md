#Pitaya ![Platform](https://img.shields.io/cocoapods/p/Kingfisher.svg?style=flat) ![License](https://img.shields.io/cocoapods/l/Kingfisher.svg?style=flat) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

Pitaya is a sweet HTTP networking library especially for large file uploads written in Swift. Inspired by [Alamofire](https://github.com/Alamofire/Alamofire) and [JustHTTP](https://github.com/JustHTTP/Just).

####[Read the documentation](https://github.com/johnlui/Pitaya/wiki)

![Pitaya logo](https://raw.githubusercontent.com/johnlui/Pitaya/master/Pitaya.png)

##Features

- [x] Fast file upload through "Content-Type: multipart/form-data"
- [x] HTTP Basic Authorization supported
- [x] Asynchronous & Blocking ( blocked in thread II )
- [x] Multi-level API to keep your code clean
- [x] Well tested
- [ ] Fully JSON support
- [ ] Asynchronous and synchronous support

##Requirements

* iOS 8.0+
* Xcode 6.4 (Swift 1.2) before [v0.2.3](https://github.com/johnlui/Pitaya/releases/tag/v0.2.3)
* Xcode 7 (Swift 2.0) in current master branch.

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

##Use

###Import
If you drag Pitaya project into your project, you may need to import it before use it:

```swift
import Pitaya
```

If you use Pitaya by Drag `Pitaya/Pitaya/Pitaya.swift` into your project.

###GET

Just give Google a hit:

```swift
Pitaya.request(.GET, url: "https://www.google.com", errorCallback: nil, callback: nil)
```

###GET with callback

```swift
Pitaya.request(.GET, url: "http://httpbin.org/get", errorCallback: nil) { (data, response) -> Void in
    print("Got it!")
}
```
##### [More Request documentation](https://github.com/johnlui/Pitaya/wiki/Request)

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
