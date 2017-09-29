//
//  authorViewController.swift
//  KC-JSONReader
//
//  Created by Kartheek chintalapati on 29/09/17.
//  Copyright © 2017 Northern Illinois University. All rights reserved.
//
/*************************************************************************
 * This is used to display author page in a web view                     *
 *************************************************************************/

import UIKit

class authorViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let path = Bundle.main.path(forResource: "/html/index", ofType: "html")!
        let data:NSData = NSData(contentsOfFile:path)!
        let html = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)
        
        // Load the webView outlet with the content of the index.html file
        webView.loadHTMLString(html! as String, baseURL: Bundle.main.bundleURL)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
