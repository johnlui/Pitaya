//
//  File.swift
//  Pitaya
//
//  Created by 吕文翰 on 15/10/7.
//  Copyright © 2015年 http://lvwenhan.com. All rights reserved.
//

import Foundation

public struct File {
    let name: String!
    let url: NSURL!
    public init(name: String, url: NSURL) {
        self.name = name
        self.url = url
    }
}