//
//  ViewController.swift
//  KRWebView
//
//  Created by Birapuram Kumar Reddy on 11/20/17.
//  Copyright © 2017 KRiOSApps. All rights reserved.
//

import UIKit
import WebKit
import Alamofire

class ViewController: UIViewController,UIWebViewDelegate {

    var webview : UIWebView?
    var wkWebView : WKWebView?

    override func loadView() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            let configuration = WKWebViewConfiguration()
            configuration.setURLSchemeHandler(CustomeSchemeHandler(), forURLScheme: Constants.customURLScheme)
            wkWebView = WKWebView(frame: .zero,configuration:configuration)
            view = wkWebView
        }else{
            webview = UIWebView(frame: .zero)
            view = webview
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadHtmlIntoWebview()
    }

    internal func loadHtmlIntoWebview() -> Void {
        if #available(iOS 11.0 , *){
            let fileURL = Bundle.main.url(forResource: "sample", withExtension: "html")
            wkWebView?.loadFileURL(fileURL!, allowingReadAccessTo: fileURL!)
        }else{
            do{
                let htmlFile = Bundle.main.url(forResource: "sample", withExtension: "html")
                let htmlText = try String(contentsOf: htmlFile!, encoding: String.Encoding.utf8)
                webview?.loadHTMLString(htmlText, baseURL: nil)
            }catch{
                print("error in parsing the file \(error.localizedDescription)")
            }
        }
    }
}

