//
//  authorViewController.swift
//  jsonReader
//
//  Created by Kartheek chintalapati on 26/09/17.
//  Copyright © 2017 Kartheek Chintalapati. All rights reserved.
//
/********************************************************************************************
 Holds code to display web page of author in author view controller.
 ********************************************************************************************/

import UIKit

class authorViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create a path to the index.html "data" file bundled under the "html" folder
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
