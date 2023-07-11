//
//  WikiViewController.swift
//  Project16-MapKit
//
//  Created by dnlab on 2023/07/09.
//
import WebKit
import UIKit

class WikiViewController:
    UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var city = ""
    // When using WKWebView, remember to add "loadView()"!!!
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("City chosen: \(city)")
        guard let url = URL(string: "https://en.wikipedia.org/wiki/\(city)") else { return }
        print(url)
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
