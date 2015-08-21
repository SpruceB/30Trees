//
//  HelpPageViewController.swift
//  30Trees
//
//  Created by Spruce Bondera on 8/15/15.
//  Copyright © 2015 Spruce Bondera. All rights reserved.
//

import UIKit

class HelpPageViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet var webView: UIWebView!
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        print("Request")
        print(request)
        return true
    }
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        print(error)
        print("load failed")
    }
    override func viewDidLoad() {
        webView.delegate = self
        print(NSBundle.mainBundle().pathForResource("tutorial", ofType: "rtfd"))
        if let resource = NSBundle.mainBundle().URLForResource("test", withExtension: "html") {
            print(resource)
            let google = NSURL(string: "https://www.google.com")
            let request = NSURLRequest(URL: resource)
            webView.loadRequest(request)
            print(resource)
        } else {
            print("fail")
        }
        self.view.addSubview(webView)
    }
}
