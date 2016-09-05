//
//  ViewController.swift
//  PitayaExample
//
//  Created by BrikerMan on 16/9/5.
//  Copyright © 2016年 BrikerMan. All rights reserved.
//

import UIKit
import Pitaya

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Pita.build(HTTPMethod: .GET, url: "https://httpbin.org/get?hello=Hello%20Pitaya!")
            .responseJSON { (json, response) -> Void in
                print(json["args"]["hello"].stringValue) // get "Hello Pitaya!"
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

