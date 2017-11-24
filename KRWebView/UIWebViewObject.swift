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

class UIWebViewObject : NSObject,UIWebViewDelegate {

    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true;
    }
}

class CustomNSURLProtocol: URLProtocol,NSURLConnectionDelegate,URLSessionDelegate,URLSessionTaskDelegate {

    override class func canInit(with request: URLRequest) -> Bool {
        print("UIWebivew request \(request.url!)")
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
        //let connection = NSURLConnection(request: self.request, delegate: self)
        //connection?.start()

        /*let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        session.dataTask(with: self.request.url!) { (data, response, error) in
            print("working");
        }.resume()*/
        DispatchQueue.global().async {
            if let url = self.request.url, url.scheme == Constants.customURLScheme {
                if let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: true)?.queryItems {
                    for queryParams in queryItems {
                        if queryParams.name == "type" && queryParams.value == "remote" {
                            let queryItem = queryItems.filter({ $0.name == "url" })
                            let value = queryItem[0].value?.replacingOccurrences(of: "\\", with: "")
                            Alamofire.request(value!).responseJSON(completionHandler: {(response) in
                                self.client?.urlProtocol(self, didReceive: response.response!, cacheStoragePolicy: .notAllowed)
                                self.client?.urlProtocol(self, didLoad: response.data!)
                                self.client?.urlProtocolDidFinishLoading(self)
                            })
                        }
                    }
                }
            }
        }
    }

    override func stopLoading() {

    }

}
