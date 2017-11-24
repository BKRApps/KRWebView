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

    let webDelegate : UIWebViewObject = {
        return UIWebViewObject()
    }()

    let wkWebViewDelegate : WKWebViewObject = {
        return WKWebViewObject()
    }()

    override func loadView() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            let configuration = WKWebViewConfiguration()
            configuration.setURLSchemeHandler(CustomeSchemeHandler(), forURLScheme: Constants.customURLScheme)
            wkWebView = WKWebView(frame: .zero,configuration:configuration)
            wkWebView?.navigationDelegate = wkWebViewDelegate
            view = wkWebView
        }else{
            webview = UIWebView(frame: .zero)
            webview?.delegate = webDelegate
            view = webview
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadHtmlIntoWebview()
    }

    internal func loadHtmlIntoWebview() -> Void {
        if #available(iOS 11.0 , *){
            let fileURL = Bundle.main.url(forResource: "sample", withExtension: "html")
            wkWebView?.loadFileURL(fileURL!, allowingReadAccessTo: fileURL!)
        /*let config = URLSessionConfiguration.default
            config.protocolClasses = [CustomNSURLProtocol.self]
            let mySession = Alamofire.SessionManager(configuration: config)
        mySession.request("http://placehold.it/120x120&text=image1").responseString(completionHandler: { (response) in
            print("yes done");
        })*/
        }else{
            do{
                let htmlFile = Bundle.main.url(forResource: "sample", withExtension: "html")
                let htmlText = try String(contentsOf: htmlFile!, encoding: String.Encoding.utf8)
                webview?.loadHTMLString(htmlText, baseURL: nil)
                /*Alamofire.request("http://placehold.it/120x120&text=image1").responseString(completionHandler: { (response) in
                 print("yes done");
                 })*/

                /*let config = URLSessionConfiguration.default
                config.protocolClasses = [CustomNSURLProtocol.self]
                let session = URLSession(configuration: config)
                session.dataTask(with: URL(string: "http://placehold.it/120x120&text=image1")!) { (data, response, error) in
                    print("working");
                    }.resume()*/
            }catch{
                print(error.localizedDescription)
            }
        }
    }
}

