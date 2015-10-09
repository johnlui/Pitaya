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
        // basic GET
        Pita.build(HTTPMethod: .GET, url: "https://httpbin.org/get?hello=Hello%20Pitaya!")
            .responseJSON { (json, response) -> Void in
                print(json["args"]["hello"].stringValue)
        }
        
        // SSL pinning success
        Pita.build(HTTPMethod: .GET, url: "https://lvwenhan.com/")
            .addSSLPinning(LocalCertData: NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("lvwenhancom", ofType: "cer")!)!) { () -> Void in
                print("Under Man-in-the-middle attack!")
            }
            .responseString { (string, response) -> Void in
                print("HTTP status: " + response!.statusCode.description)
        }
    }
}

