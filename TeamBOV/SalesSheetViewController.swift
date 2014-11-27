//
//  SalesSheetViewController.swift
//  TeamBOV
//
//  Created by Stephen Kyles on 11/22/14.
//  Copyright (c) 2014 Blue Owl Labs. All rights reserved.
//

import UIKit

class SalesSheetViewController: UIViewController, UIWebViewDelegate {
    var pdf: String!
    
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        var backbutton = UIBarButtonItem(image: UIImage(named: "back"), style: .Plain, target: self, action: "goBack")
        navigationItem.leftBarButtonItem = backbutton
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        var url = NSURL(fileURLWithPath: pdf)
        var urlRequest = NSURLRequest(URL: url!)
        
        webView.loadRequest(urlRequest)
        webView.userInteractionEnabled = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goBack() {
        navigationController?.popViewControllerAnimated(true)
    }
}
