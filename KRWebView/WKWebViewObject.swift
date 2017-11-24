//
//  WKWebViewObject.swift
//  KRWebView
//
//  Created by Birapuram Kumar Reddy on 11/20/17.
//  Copyright © 2017 KRiOSApps. All rights reserved.
//

import UIKit
import WebKit
import Alamofire

enum WebErrors: Error {
    case RequestFailedError
}


class WKWebViewObject: NSObject,WKNavigationDelegate {
    
}

@available(iOS 11.0, *)
class CustomeSchemeHandler : NSObject,WKURLSchemeHandler {

    var imagePicker : ImagePicker!
    func webView(_ webView: WKWebView, start urlSchemeTask: WKURLSchemeTask) {
        print("Request : \(urlSchemeTask.request.url!)")
        DispatchQueue.global().async {
            if let url = urlSchemeTask.request.url, url.scheme == Constants.customURLScheme {
                if let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: true)?.queryItems {
                    for queryParams in queryItems {
                        if queryParams.name == "type" && queryParams.value == "remote" {
                            let queryItem = queryItems.filter({ $0.name == "url" })
                            let value = queryItem[0].value?.replacingOccurrences(of: "\\", with: "")
                            Alamofire.request(value!).responseJSON(completionHandler: {(response) in
                                urlSchemeTask.didReceive(response.response!)
                                urlSchemeTask.didReceive(response.data!)
                                urlSchemeTask.didFinish()
                            })
                        }else if queryParams.name == "type" && queryParams.value == "local" {
                            DispatchQueue.main.async {
                                self.imagePicker = ImagePicker()
                                self.imagePicker.showGallery(cHandler: { (response, data) in
                                    urlSchemeTask.didReceive(response!)
                                    urlSchemeTask.didReceive(data!)
                                    urlSchemeTask.didFinish()
                                })
                            }
                        }
                    }
                }
            }
        }
    }

    func webView(_ webView: WKWebView, stop urlSchemeTask: WKURLSchemeTask) {
        urlSchemeTask.didFailWithError(WebErrors.RequestFailedError)
    }
}
