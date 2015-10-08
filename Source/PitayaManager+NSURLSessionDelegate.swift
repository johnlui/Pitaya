//
//  PitayaManager+NSURLSessionDelegate.swift
//  Pitaya
//
//  Created by 吕文翰 on 15/10/8.
//  Copyright © 2015年 http://lvwenhan.com. All rights reserved.
//

private typealias URLSessionDelegate = PitayaManager

extension URLSessionDelegate {
    
    @objc public func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
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
                NSLog("Pitaya: Get RemoteCertificateData or LocalCertificateData error!")
            }
        } else {
            completionHandler(NSURLSessionAuthChallengeDisposition.UseCredential, nil)
        }
    }
}