Pitaya
----------
![Platform](https://camo.githubusercontent.com/770175f6c01d89c84a020706126a9e6399ff76c4/68747470733a2f2f696d672e736869656c64732e696f2f636f636f61706f64732f702f4b696e676669736865722e7376673f7374796c653d666c6174) ![License](https://img.shields.io/github/license/johnlui/Pitaya.svg?style=flat) ![Language](https://img.shields.io/badge/language-Swift%202-orange.svg) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![Travis](https://img.shields.io/travis/johnlui/Pitaya.svg)](https://travis-ci.org/johnlui/Pitaya)

![Pitaya logo](https://raw.githubusercontent.com/johnlui/Pitaya/master/Pitaya.png?re=new)

> Thus, programs must be written for people to read, and only incidentally for machines to execute.
> 
> Harold Abelson, "[Structure and Interpretation of Computer Programs](https://mitpress.mit.edu/sicp/front/node3.html)" ( S.I.C.P )

Pitaya is a Swift HTTP / HTTPS networking library for people. Inspired by [Alamofire](https://github.com/Alamofire/Alamofire) and [JustHTTP](https://github.com/JustHTTP/Just).

## Example

```swift
Pita.build(HTTPMethod: .GET, url: "https://httpbin.org/get?hello=Hello%20Pitaya!")
    .responseJSON { (json, response) -> Void in
        print(json["args"]["hello"].stringValue) // get "Hello Pitaya!"
}
```

##### [Read the documentation](https://github.com/johnlui/Pitaya/wiki).

###They are all Asynchronous.

##Features

- [x] Elegant APIs for people
- [x] Support HTTP Basic Authorization
- [x] Support setting SSL pinning
- [x] Support setting HTTP raw body (include [JSON body](https://github.com/johnlui/Pitaya/wiki#http-raw-body))
- [x] Asynchronous & Queue
- [x] Upload files fast
- [x] Internal fully JSON support with [JSONNeverDie](https://github.com/johnlui/JSONNeverDie)
- [x] 100% tested

##Requirements

* iOS 7.0+
* Xcode 6.4 (Swift 1.2) before [v0.2.3](https://github.com/johnlui/Pitaya/releases/tag/v0.2.3)
* Xcode 7 (Swift 2) in current master branch.

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
open .
```
then drag Pitaya.xcodeproj into your Project, that's it!

If you want to run your project on devices with Pitaya, just go to PROJECT->TARGETS->[your project name]->General->Embedded Binaries, click ＋, select Pitaya.frameWork and click "Add".

###Source File

Clone all files in the `Source` directory into your project.


##Contribution

You are welcome to fork and submit pull requests.

##License

Pitaya is open-sourced software licensed under the MIT license.
