//
//  ViewController.swift
//  PitayaExample
//
//  Created by JohnLui on 15/5/14.
//  Copyright (c) 2015年 http://lvwenhan.com. All rights reserved.
//

import UIKit
import Pitaya

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
//        Pitaya.DEBUG = true
        Pitaya.request(.GET, url: "http://httpbin.org/get", errorCallback: nil) { (data, response) -> Void in
            for (i,j) in response!.allHeaderFields {
                print("\(i): \(j)")
            }
        }
        /*
        Pitaya.request(.GET, url: "http://staticonsae.sinaapp.com/pitaya.php", errorCallback: { (error) -> Void in
            NSLog(error.localizedDescription)
            }) { (data, response) -> Void in
                let string = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
                print("HTTP body: " + string, terminator: "\n")
                print("HTTP status: " + response!.statusCode.description, string, terminator: "\n")
        }
        Pitaya.request(.POST, url: "http://staticonsae.sinaapp.com/pitaya.php", params: ["post": "pitaya"], errorCallback: { (error) -> Void in
            NSLog(error.localizedDescription)
            }) { (data, response) -> Void in
                let string = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
                print("HTTP body: " + string, string, terminator: "\n")
                print("HTTP status: " + response!.statusCode.description, string, terminator: "\n")
        }
        let file = File(name: "file", url: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Pitaya", ofType: "png")!))
        Pitaya.request(.POST, url: "http://staticonsae.sinaapp.com/pitaya.php", files: [file], errorCallback: { (error) -> Void in
            NSLog(error.localizedDescription)
            }) { (data, response) -> Void in
                let string = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
                print("HTTP body: " + string, string, terminator: "\n")
                print("HTTP status: " + response!.statusCode.description, string, terminator: "\n")
        }
        let pitaya = PitayaManager.build(.POST, url: "http://httpbin.org/post")
        pitaya.setHTTPBodyRaw("{\"fuck\":\"you\"}")
        pitaya.fire({ (error) -> Void in
            NSLog(error.localizedDescription)
            }) { (data, response) -> Void in
                let string = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
                print("HTTP body: " + string, string, terminator: "\n")
                print("HTTP status: " + response!.statusCode.description, string, terminator: "\n")
        }
        */
    }

}

