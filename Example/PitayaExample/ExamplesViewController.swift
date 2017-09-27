//
//  ExamplesViewController.swift
//  PitayaExample
//
//  Created by 吕文翰 on 16/12/16.
//  Copyright © 2016年 http://lvwenhan.com. All rights reserved.
//

import UIKit
import Pitaya

enum RequestType: String {
    case SimpleGET, SimplePOST, GETWithStringOrNumberParams, POSTWithStringOrNumberParams, UploadFilesByURL, UploadFilesByData, SetHTTPHeaders, SetHTTPRawBody, HTTPBasicAuth, AddSSLPinning, AddManySSLPinning, SyncRequest
}

class ExamplesViewController: UIViewController {
    
    var requestType: RequestType!

    @IBOutlet weak var fireUpButton: UIButton!
    @IBOutlet weak var resultLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fireUpButton.setTitle(self.requestType.rawValue, for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.clearAllNotice()
    }
    
    @IBAction func FireUpButtonBeTapped(_ sender: Any) {
        
        self.perform(Selector(self.requestType.rawValue))
    }
    
    func SimpleGET() {
        self.pleaseWait()
        Pita.build(HTTPMethod: .GET, url: "http://httpbin.org/get")
            .responseString { (string, nil) in
                self.resultLabel.text = string
                self.clearAllNotice()
        }
    }
    func SimplePOST() {
        self.pleaseWait()
        Pita.build(HTTPMethod: .POST, url: "http://httpbin.org/post")
            .addParams(["key": "pitaaaaaaaaaaaaaaaya"])
            .responseString { (string, nil) in
                self.resultLabel.text = string
                self.clearAllNotice()
        }
    }
    func GETWithStringOrNumberParams() {
        self.pleaseWait()
        Pita.build(HTTPMethod: .GET, url: "http://httpbin.org/get")
            .addParams(["key": "pitaaaaaaaaaaaaaaaya"])
            .responseString { (string, nil) in
                self.resultLabel.text = string
                self.clearAllNotice()
        }
    }
    func POSTWithStringOrNumberParams() {
        self.pleaseWait()
        Pita.build(HTTPMethod: .POST, url: "http://httpbin.org/post")
            .addParams(["key": "pitaaaaaaaaaaaaaaaya"])
            .responseString { (string, nil) in
                self.resultLabel.text = string
                self.clearAllNotice()
        }
    }
    func UploadFilesByURL() {
        let fileURL = Bundle(for: ExamplesViewController.self).url(forResource: "logo@2x", withExtension: "jpg")!
        let file = File(name: "file", url: fileURL)
        
        self.pleaseWait()
        Pita.build(HTTPMethod: .POST, url: "http://tinylara.com:8000/pitaya.php")
            .addFiles([file])
            .responseString({ (string, response) -> Void in
                self.resultLabel.text = string == "1" ? "success" : "failure"
                self.clearAllNotice()
        })
    }
    func UploadFilesByData() {
        let fileURL = Bundle(for: ExamplesViewController.self).url(forResource: "logo@2x", withExtension: "jpg")!
        let data = try! Data(contentsOf: fileURL)
        let file = File(name: "file", data: data, type: "jpg")
        
        self.pleaseWait()
        Pita.build(HTTPMethod: .POST, url: "http://tinylara.com:8000/pitaya.php")
            .addFiles([file])
            .responseString({ (string, response) -> Void in
                self.resultLabel.text = string == "1" ? "success" : "failure"
                self.clearAllNotice()
            })
    }
    func SetHTTPHeaders() {
        self.pleaseWait()
        Pita.build(HTTPMethod: .GET, url: "http://httpbin.org/headers")
            .setHTTPHeader(Name: "Accept-Language", Value: "Pitaya Language")
            .setHTTPHeader(Name: "pitaaaaaaaaaaaaaaa", Value: "ya")
            .responseString { (string, nil) in
                self.resultLabel.text = string
                self.clearAllNotice()
        }
    }
    func SetHTTPRawBody() {
        let jsonString = JSONND(dictionary: ["key": "pitaaaaaaaaaaaaaaaya"]).RAWValue
        self.pleaseWait()
        Pita.build(HTTPMethod: .POST, url: "http://httpbin.org/post")
            .setHTTPBodyRaw(jsonString, isJSON: true)
            .responseString { (string, nil) in
                self.resultLabel.text = string
                self.clearAllNotice()
        }
    }
    func HTTPBasicAuth() {
        self.pleaseWait()
        Pita.build(HTTPMethod: .GET, url: "http://httpbin.org/basic-auth/user/passwd")
            .setBasicAuth("user", password: "passwd")
            .responseString { (string, nil) in
                self.resultLabel.text = string
                self.clearAllNotice()
        }
    }
    func AddSSLPinning() {
        let certURL = Bundle(for: ExamplesViewController.self).url(forResource: "lvwenhancom", withExtension: "cer")!
        let certData = try! Data(contentsOf: certURL)
        
        self.pleaseWait()
        Pita.build(HTTPMethod: .GET, url: "https://lvwenhan.com/")
            .addSSLPinning(LocalCertData: certData, SSLValidateErrorCallBack: { () -> Void in
                self.noticeOnlyText("Under the Man-in-the-middle attack!")
            })
            .responseString { (string, nil) in
                self.resultLabel.text = "lvwenhan.com success"
                self.clearAllNotice()
        }
        
        self.pleaseWait()
        Pita.build(HTTPMethod: .GET, url: "https://httpbin.org/get")
            .addSSLPinning(LocalCertData: certData, SSLValidateErrorCallBack: { () -> Void in
                self.clearAllNotice()
                self.noticeOnlyText("httpbin.org is Under the \nMan-in-the-middle attack!")
            })
            .responseString { (string, nil) in
                self.resultLabel.text = "success"
        }
    }
    func AddManySSLPinning() {
        let certURL0 = Bundle(for: ExamplesViewController.self).url(forResource: "lvwenhancom", withExtension: "cer")!
        let certData0 = try! Data(contentsOf: certURL0)
        
        let certURL1 = Bundle(for: ExamplesViewController.self).url(forResource: "logo@2x", withExtension: "jpg")!
        let certData1 = try! Data(contentsOf: certURL1)
        
        self.pleaseWait()
        Pita.build(HTTPMethod: .GET, url: "https://lvwenhan.com/")
            .addSSLPinning(LocalCertDataArray: [certData0, certData1], SSLValidateErrorCallBack: { () -> Void in
                self.noticeOnlyText("Under the Man-in-the-middle attack!")
            })
            .responseString { (string, nil) in
                self.resultLabel.text = "lvwenhan.com success"
                self.clearAllNotice()
        }
        
        self.pleaseWait()
        Pita.build(HTTPMethod: .GET, url: "https://httpbin.org/get")
            .addSSLPinning(LocalCertDataArray: [certData0, certData1], SSLValidateErrorCallBack: { () -> Void in
                self.clearAllNotice()
                self.noticeOnlyText("httpbin.org is Under the \nMan-in-the-middle attack!")
            })
            .responseString { (string, nil) in
                self.resultLabel.text = "success"
        }
    }

    func SyncRequest(){
        Pita.build(HTTPMethod: .GET, url: "http://httpbin.org/delay/3", timeout: 10, execution: .sync).responseString { (string, response) in
            self.resultLabel.text = string
        }
    }
}
