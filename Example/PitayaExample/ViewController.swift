//
//  ViewController.swift
//  PitayaExample
//
//  Created by JohnLui on 15/5/14.
//  Copyright (c) 2015年 http://lvwenhan.com. All rights reserved.
//

import UIKit
import Pitaya
import JSONNeverDie

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func mainButtonBeTapped(sender: AnyObject) {
        // basic GET
        Pita.build(HTTPMethod: .GET, url: "https://httpbin.org/get?hello=Hello%20Pitaya!")
            .responseJSON { (json, response) -> Void in
                print(json["args"]["hello"].stringValue)
        }
        
        // A request with Params, Files, Basic Auth, SSL pinning, HTTP Raw Body and NetworkError callback
        let file = File(name: "file", url: NSBundle.mainBundle().URLForResource("Pitaya", withExtension: "png")!)
        let certData = NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("lvwenhancom", ofType: "cer")!)!
        let json: JSONND = ["user": "JohnLui", "love": "you"]
        Pita.build(HTTPMethod: .GET, url: "https://lvwenhan.com/")
            .addParams(["hello": "params"])
            .addFiles([file])
            .setHTTPHeader(Name: "Accept", Value: "application/json")
            .setBasicAuth("user", password: "passwd")
            .setHTTPBodyRaw(json.jsonStringValue)
            .onNetworkError({ (error) -> Void in
                print("network offline!")
            })
            .addSSLPinning(LocalCertData: certData) { () -> Void in
                print("Under Man-in-the-middle attack!")
            }
            .responseString { (string, response) -> Void in
                print("HTTP status: " + response!.statusCode.description)
        }
    }
}

