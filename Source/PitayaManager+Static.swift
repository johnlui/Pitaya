//
//  PitayaManager+PublicStatic.swift
//  Pitaya
//
//  Created by 吕文翰 on 15/10/8.
//  Copyright © 2015年 http://lvwenhan.com. All rights reserved.
//

extension PitayaManager {
    static func build(method: HTTPMethod, url: String) -> PitayaManager {
        return PitayaManager(url: url, method: method)
    }
}