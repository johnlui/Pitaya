// The MIT License (MIT)

// Copyright (c) 2015 JohnLui <wenhanlv@gmail.com> https://github.com/johnlui

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//
//  File.swift
//  Pitaya
//
//  Created by 吕文翰 on 15/10/7.
//

import Foundation

/**
*  the file struct for Pitaya to upload
*/
public struct File {
    public let name: String
    public let nameWithType: String
    public let url: URL?
    public let data: Data?
    
    public init(name: String, url: URL) {
        self.name = name
        self.url = url
        self.data = nil
        self.nameWithType = NSString(string: url.description).lastPathComponent
    }
    
    public init(name:String, data: Data, type: String) {
        self.name = name
        self.data = data
        self.url  = nil
        self.nameWithType = name + "." + type
    }
}
