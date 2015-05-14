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
        Pitaya.request(.GET, "http://pitayaswift.sinaapp.com/pitaya.php", { (error) -> Void in
            NSLog(error.localizedDescription)
            }) { (string) -> Void in
                println(string)
        }
        Pitaya.request(.GET, "http://pitayaswift.sinaapp.com/pitaya.php", ["get": "pitaya"], { (error) -> Void in
            NSLog(error.localizedDescription)
            }) { (string) -> Void in
                println(string)
        }
    }

}

