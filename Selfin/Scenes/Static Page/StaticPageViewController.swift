
//
//  StaticPageViewController.swift
//  Selfin
//
//  Created by cis on 20/09/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit
import WebKit
class StaticPageViewController: UIViewController {

    var heading = String()
    @IBOutlet weak var lblHeading: UINavigationItem!
    var webViewStaticContent: WKWebView!

    override func loadView() {
        super.loadView()
        let webConfiguration = WKWebViewConfiguration()
        webViewStaticContent = WKWebView(frame: .zero, configuration: webConfiguration)
        webViewStaticContent.navigationDelegate = self
        view = webViewStaticContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = false
        backButton()
        lblHeading.title = heading

        showLoader()
        switch lblHeading.title {
        case StaticPageHeader.faq.rawValue:
            let myRequest = URLRequest(url: URL(string: environment.host + "/" + SelfinRequestedURL.FrequentlyAskedQuestions())!)
            webViewStaticContent.load(myRequest)
        case StaticPageHeader.terms.rawValue:
            let myRequest = URLRequest(url: URL(string: environment.host + "/" + SelfinRequestedURL.TermOfUses())!)
            webViewStaticContent.load(myRequest)
        case StaticPageHeader.privacyPolicy.rawValue, StaticPageHeader.policies.rawValue:
            let myRequest = URLRequest(url: URL(string: environment.host + "/" + SelfinRequestedURL.PrivacyPolicy())!)
            webViewStaticContent.load(myRequest)
        case StaticPageHeader.contactUs.rawValue:
            let myRequest = URLRequest(url: URL(string: environment.host + "/" + SelfinRequestedURL.ContactUs())!)
            webViewStaticContent.load(myRequest)
        case StaticPageHeader.policiesT.rawValue:
            let myRequest = URLRequest(url: URL(string: environment.host + "/" + SelfinRequestedURL.AcceptTermOfUse())!)
            webViewStaticContent.load(myRequest)
        default:
            break
        }
    }
}

extension StaticPageViewController:WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideLoader()
    }
}

