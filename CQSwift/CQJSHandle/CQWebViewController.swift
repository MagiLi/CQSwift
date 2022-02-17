//
//  CQWebViewController.swift
//  CQSwift
//
//  Created by llbt2019 on 2021/10/13.
//  Copyright © 2021 李超群. All rights reserved.
//

import UIKit
import JavaScriptCore

class CQWebViewController: UIViewController, UIWebViewDelegate {

//    var client:CQJSClient?
    var jsContext:JSContext?
    //MARK:UIWebViewDelegate
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        guard let jsContext = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext else {
            debugPrint("JSContext get failed !")
            return true
        }
        let client = CQJSClient()
        client.jsContext = jsContext
        jsContext.setObject(client, forKeyedSubscript: "client" as (NSCopying & NSObjectProtocol))
        return true
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        debugPrint("webViewDidFinishLoad")
        guard let jsContext = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext else {
            debugPrint("JSContext get failed !")
            return
        }
//        jsContext["nativeAlert"] = {
//
//        }
        let client = CQJSClient()
        client.jsContext = jsContext
        jsContext.setObject(client, forKeyedSubscript: "client" as (NSCopying & NSObjectProtocol))
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL.init(string: "http://apit1.leye.ccb.com/static/test/hzn/index.html")
        let request = URLRequest.init(url: url!)
        self.webView.loadRequest(request)
        
        self.view.addSubview(self.webView)
    }
      
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.webView.frame = self.view.bounds
    }
    
    lazy var webView: UIWebView = {
        let webV = UIWebView()
        webV.delegate = self
        return webV
    }()

}
