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
        Pitaya.request(.GET, url: "http://pitayaswift.sinaapp.com/pitaya.php", errorCallback: { (error) -> Void in
            NSLog(error.localizedDescription)
            }) { (string) -> Void in
                print(string)
        }
        Pitaya.request(.POST, url: "http://pitayaswift.sinaapp.com/pitaya.php", params: ["post": "pitaya"], errorCallback: { (error) -> Void in
            NSLog(error.localizedDescription)
            }) { (string) -> Void in
                print(string)
        }
        let file = File(name: "file", url: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Pitaya", ofType: "png")!))
        Pitaya.request(.POST, url: "http://pitayaswift.sinaapp.com/pitaya.php", files: [file], errorCallback: { (error) -> Void in
            NSLog(error.localizedDescription)
            }) { (string) -> Void in
                print(string)
        }
        let pitaya = PitayaManager.build(.GET, url: "http://httpbin.org/basic-auth/user/passwd")
        pitaya.fireWithBasicAuth(("user", "passwd"), errorCallback: { (error) -> Void in
            NSLog(error.localizedDescription)
            }) { (string) -> Void in
                print(string)
        }
    }

}

