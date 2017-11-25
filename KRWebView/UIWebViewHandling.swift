//
//  WebViewDelegates.swift
//  KRWebView
//
//  Created by Birapuram Kumar Reddy on 11/20/17.
//  Copyright © 2017 KRiOSApps. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

class CustomNSURLProtocol: URLProtocol,NSURLConnectionDelegate,URLSessionDelegate,URLSessionTaskDelegate {

    var imagePicker : ImagePicker!

    override class func canInit(with request: URLRequest) -> Bool {
        if let url = request.url, url.scheme == Constants.customURLScheme {
            return true
        }
        return false
    }

    override class func canInit(with task: URLSessionTask) -> Bool {
        let _ = task.currentRequest?.url
        return false
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request;
    }

    override func startLoading() {
        DispatchQueue.global().async {
            if let url = self.request.url, url.scheme == Constants.customURLScheme {
                if let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: true)?.queryItems {
                    for queryParams in queryItems {
                        //example : custom-scheme:// path ? type=remote & url=http://placehold.it/120x120&text=image1
                        if queryParams.name == "type" && queryParams.value == "remote" {
                            let queryItem = queryItems.filter({ $0.name == "url" })
                            let value = queryItem[0].value?.replacingOccurrences(of: "\\", with: "")
                            Alamofire.request(value!).responseJSON(completionHandler: {(response) in
                                self.client?.urlProtocol(self, didReceive: response.response!, cacheStoragePolicy: .notAllowed)
                                self.client?.urlProtocol(self, didLoad: response.data!)
                                self.client?.urlProtocolDidFinishLoading(self)
                            })
                        }else if queryParams.name == "type" && queryParams.value == "photos" { /* example :  custom-scheme:// path ? type=photos */
                            DispatchQueue.main.async {
                                self.imagePicker = ImagePicker()
                                self.imagePicker.showGallery(cHandler: { (response, data) in
                                    self.client?.urlProtocol(self, didReceive: response!, cacheStoragePolicy: .notAllowed)
                                    self.client?.urlProtocol(self, didLoad: data!)
                                    self.client?.urlProtocolDidFinishLoading(self)
                                })
                            }
                        }
                    }
                }
            }
        }
    }

    override func stopLoading() {
        
    }

}
