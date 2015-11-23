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
//  PitayaManager+NSURLSessionDelegate.swift
//  Pitaya
//
//  Created by 吕文翰 on 15/10/8.
//

import Foundation

private typealias URLSessionDelegate = PitayaManager

extension URLSessionDelegate {
    /**
    a delegate method to check whether the remote cartification is the same with given certification.
    
    - parameter session:           NSURLSession
    - parameter challenge:         NSURLAuthenticationChallenge
    - parameter completionHandler: the completionHandler closure
    */
    @objc func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
        if let localCertificateData = self.localCertData {
            if let serverTrust = challenge.protectionSpace.serverTrust,
                certificate = SecTrustGetCertificateAtIndex(serverTrust, 0),
                remoteCertificateData: NSData = SecCertificateCopyData(certificate) {
                    if localCertificateData.isEqualToData(remoteCertificateData) {
                        let credential = NSURLCredential(forTrust: serverTrust)
                        challenge.sender?.useCredential(credential, forAuthenticationChallenge: challenge)
                        completionHandler(NSURLSessionAuthChallengeDisposition.UseCredential, credential)
                    } else {
                        challenge.sender?.cancelAuthenticationChallenge(challenge)
                        completionHandler(NSURLSessionAuthChallengeDisposition.CancelAuthenticationChallenge, nil)
                        self.sSLValidateErrorCallBack?()
                    }
            } else {
                // could not tested
                NSLog("Pitaya: Get RemoteCertificateData or LocalCertificateData error!")
            }
        } else {
            completionHandler(NSURLSessionAuthChallengeDisposition.UseCredential, nil)
        }
    }
}