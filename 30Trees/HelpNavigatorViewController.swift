//
//  HelpViewController.swift
//  30Trees
//
//  Created by Spruce Bondera on 8/15/15.
//  Copyright © 2015 Spruce Bondera. All rights reserved.
//

import UIKit
import Foundation

class HelpNavigatorViewController: UITableViewController, UIWebViewDelegate, UIDocumentInteractionControllerDelegate {
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        print("aa")
        print(error)
    }
    
    func documentInteractionControllerViewControllerForPreview(controller: UIDocumentInteractionController) -> UIViewController {
        return self.navigationController!
    }
    
    func displayWebviewFromFile(fileURL: NSURL, withTitle title: String) {
        var controller = UIViewController()
        var webview = UIWebView()
        let docs = UIDocumentInteractionController(URL: fileURL.filePathURL!)
        docs.delegate = self
        docs.presentPreviewAnimated(true)
//        let request = NSURLRequest(URL: fileURL.filePathURL!)
//        webview.loadRequest(request)
//        controller.view = webview;
//        webview.delegate = self
//        controller.navigationItem.title = fileURL.lastPathComponent
//        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row != 1 {
            let url = NSBundle.mainBundle().URLForResource("test", withExtension: "pages", subdirectory: "Help")!
            displayWebviewFromFile(url, withTitle: "Test")
            
            
        }
    }
}
