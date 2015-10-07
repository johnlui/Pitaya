//
//  String+NSData.swift
//  Pitaya
//
//  Created by 吕文翰 on 15/10/7.
//  Copyright © 2015年 http://lvwenhan.com. All rights reserved.
//

import Foundation

extension String {
    var nsdata: NSData {
        return self.dataUsingEncoding(NSUTF8StringEncoding)!
    }
}