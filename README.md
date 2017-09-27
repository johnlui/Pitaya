<p align="center">
    <a href="https://github.com/johnlui/Pitaya"><img src="https://github.com/johnlui/Pitaya/blob/swift3/assets/logo@2x.jpg"></a>
</p>

<p align="center">
    <a href="https://github.com/johnlui/Pitaya"><img src="https://img.shields.io/badge/platform-ios-lightgrey.svg"></a>
    <a href="https://github.com/johnlui/Pitaya"><img src="https://img.shields.io/github/license/johnlui/Pitaya.svg?style=flat"></a>
    <a href="https://github.com/johnlui/Pitaya"><img src="https://img.shields.io/badge/language-Swift%203-orange.svg"></a>
    <a href="https://github.com/Carthage/Carthage"><img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat"></a>
    <a href="https://travis-ci.org/johnlui/Pitaya"><img src="https://img.shields.io/travis/johnlui/Pitaya.svg"></a>
</p>

<br>

<blockquote align="center">
    <span>Thus, programs must be written for people to read, and only incidentally for machines to execute.</span>
    <br>
    <span>Harold Abelson, "<a href="https://mitpress.mit.edu/sicp/front/node3.html">Structure and Interpretation of Computer Programs</a>" ( S.I.C.P )</span>
</blockquote>

<br>

Pitaya is a Swift HTTP / HTTPS networking library for people. Inspired by [Alamofire](https://github.com/Alamofire/Alamofire) and [JustHTTP](https://github.com/JustHTTP/Just).

<br>

### [中文简介](#中文介绍)

## Example

### Simple

```swift
Pita.build(HTTPMethod: .GET, url: "https://httpbin.org/get?hello=Hello%20Pitaya!")
    .responseJSON { (json, response) -> Void in
        print(json["args"]["hello"].stringValue) // get "Hello Pitaya!"
}
```

### All examples

![All Examples](https://github.com/johnlui/Pitaya/blob/swift3/assets/PitayaExample@2x.png)

## Documentation

### [Read the documentation](https://github.com/johnlui/Pitaya/wiki)
### [中文文档](https://github.com/johnlui/Pitaya/wiki/%E4%B8%AD%E6%96%87%E6%96%87%E6%A1%A3)

## Features

- [x] Support Swift Package Manager
- [x] Elegant APIs for people
- [x] Support HTTP Basic Authorization
- [x] Support setting SSL pinning
- [x] Support setting HTTP raw body (include [JSON body](https://github.com/johnlui/Pitaya/wiki#http-raw-body))
- [x] Asynchronous & Queue
- [x] Upload files fast
- [x] Internal fully JSON support with [JSONNeverDie](https://github.com/johnlui/JSONNeverDie)
- [x] Support setting custom HTTP headers
- [x] almost 100% tested

## Requirements

* iOS 7.0+
* Xcode 9 (Swift 4) (v3.x) in current swift4 branch.
* Xcode 8 (Swift 3) (v2.x) in swift3 branch.
* Xcode 7 (Swift 2) (v1.x) in master branch.
* Xcode 6.4 (Swift 1.2) before [v0.2.3](https://github.com/johnlui/Pitaya/releases/tag/v0.2.3)

## Installation

### Swift Package Manager
You can use [The Swift Package Manager](https://swift.org/package-manager) to install `Pitaya` by adding the proper description to your `Package.swift` file:
```swift
import PackageDescription

let package = Package(
    name: "YOUR_PROJECT_NAME",
    targets: [],
    dependencies: [
        .Package(url: "https://github.com/johnlui/Pitaya.git", versions: "1.3.4" ..< Version.max)
    ]
)
```

Note that the [Swift Package Manager](https://swift.org/package-manager) is still in early design and development, for more infomation checkout it's [GitHub Page](https://github.com/apple/swift-package-manager)


### Carthage

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


### Manually

```bash
git submodule add https://github.com/johnlui/Pitaya.git
open .
```
then drag Pitaya.xcodeproj into your Project, that's it!

If you want to run your project on devices with Pitaya, just go to PROJECT->TARGETS->[your project name]->General->Embedded Binaries, click ＋, select Pitaya.frameWork and click "Add".

### Source File

Clone all files in the `Source` directory into your project.


## Contribution

You are welcome to fork and submit pull requests.

## License

Pitaya is open-sourced software licensed under the MIT license.

# 中文介绍

> Thus, programs must be written for people to read, and only incidentally for machines to execute.（代码是写给人看的，只是恰好能运行。）
> 
> Harold Abelson, "[Structure and Interpretation of Computer Programs](https://mitpress.mit.edu/sicp/front/node3.html)" ( S.I.C.P )

Pitaya(火龙果) 是一个写给人看的纯 Swift 写成的 HTTP / HTTPS 网络库。从 [Alamofire](https://github.com/Alamofire/Alamofire) 和 [JustHTTP](https://github.com/JustHTTP/Just) 偷了一些创意和代码。

## 使用示例

### 基本用法

```swift
Pita.build(HTTPMethod: .GET, url: "https://httpbin.org/get?hello=Hello%20Pitaya!")
    .responseJSON { (json, response) -> Void in
        print(json["args"]["hello"].stringValue) // get "Hello Pitaya!"
}
```

### 所有用法

![All Examples](https://github.com/johnlui/Pitaya/blob/swift3/assets/PitayaExample@2x.png)

### [中文文档](https://github.com/johnlui/Pitaya/wiki/%E4%B8%AD%E6%96%87%E6%96%87%E6%A1%A3)

## 功能

- [x] 支持 Swift Package Manager
- [x] 写给人用的优雅 API
- [x] 支持 HTTP Basic Authorization
- [x] 支持设置 SSL 钢钉，防“中间人攻击”
- [x] 支持设置 HTTP raw body (支持 [JSON body](https://github.com/johnlui/Pitaya/wiki#http-raw-body))
- [x] 异步、队列
- [x] 快速文件上传
- [x] 内置 [JSONNeverDie](https://github.com/johnlui/JSONNeverDie)，完全支持 JSON 数据
- [x] 支持设定 HTTP headers
- [x] 几乎 100% 测试率

## 环境要求

* iOS 7.0+
* Xcode 8 (Swift 4) v3.x 版，位于 swift4 分支（当前默认版本）
* Xcode 8 (Swift 3) v2.x 版，位于 swift3 分支
* Xcode 7 (Swift 2) v1.x 版，位于 master 分支
* Xcode 6.4 (Swift 1.2) 版： [v0.2.3](https://github.com/johnlui/Pitaya/releases/tag/v0.2.3)

## 安装

### Swift Package Manager

[The Swift Package Manager](https://swift.org/package-manager) 是苹果伴随 Swift 开源而推出的 Swift 语言包管理工具。

编辑你项目的 `Package.swift`：

```swift
import PackageDescription

let package = Package(
    name: "YOUR_PROJECT_NAME",
    targets: [],
    dependencies: [
        .Package(url: "https://github.com/johnlui/Pitaya.git", versions: "1.3.4" ..< Version.max)
    ]
)
```

[Swift Package Manager](https://swift.org/package-manager) 依然在开发中，功能不太稳定，建议关注它的 [GitHub Page](https://github.com/apple/swift-package-manager)。

### Carthage

[Carthage](https://github.com/Carthage/Carthage) 是一个去中心化的 Cocoa 应用程序自动依赖添加工具。

使用以下命令安装 Carthage

```bash
$ brew update
$ brew install carthage
```

安装好 Carthage 后，将下列内容加入你项目的 Cartfile:

```json
github "JohnLui/Pitaya"
```

自动下载、编译 Pitaya:

```bash
carthage update
```

最后，在 general panel 里 的 "Embedded Binaries" 项下点击 "Add Other..." 按钮，Pitaya.framework 已经躺在了 `./Carthage/Build/iOS` 目录里。
> 这种方法目前还不支持 BITCODE，如果需要支持，请直接将 Pitaya.xcodeproj 拖入你的工程。

### 手动安装

```bash
git clone https://github.com/johnlui/Pitaya.git
open Pitaya
```
在打开的 Finder 窗口中把 Pitaya.xcodeproj 拖到 Xcode 你的文件树里。

真机调试还需要额外的一步：打开 PROJECT->TARGETS->[your project name]->General，找到 Embedded Binaries, 点击 ＋, 选中 Pitaya.framework，点击“Add”即可。

### 源代码安装

把 `Source` 文件夹下的文件拖进你的文件树里即可。

## 参与开源

欢迎提交 issue 和 PR，大门永远向所有人敞开。

## 开源协议

本项目遵循 MIT 协议开源，具体请查看根目录下的 LICENSE 文件。

