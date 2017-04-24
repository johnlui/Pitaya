//
//  RootTableViewController.swift
//  PitayaExample
//
//  Created by 吕文翰 on 16/12/15.
//  Copyright © 2016年 http://lvwenhan.com. All rights reserved.
//

import UIKit

class RootTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Pitaya Example"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showExamplesVC", sender: tableView.cellForRow(at: indexPath))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let a = segue.destination as? ExamplesViewController,
            let index = (self.tableView.indexPathForSelectedRow as NSIndexPath?)?.row {
            let typeString = ["SimpleGET", "SimplePOST", "GETWithStringOrNumberParams", "POSTWithStringOrNumberParams", "UploadFilesByURL", "UploadFilesByData", "SetHTTPHeaders", "SetHTTPRawBody", "HTTPBasicAuth", "AddSSLPinning", "AddManySSLPinning", "SyncRequest"][index]
            a.requestType = RequestType(rawValue: typeString)
        }
    }
}
