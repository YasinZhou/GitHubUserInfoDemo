//
//  RepoWebViewController.swift
//  GitHubUserInfoDemo
//
//  Created by Yasin on 11/20/19.
//  Copyright © 2019 Yasin. All rights reserved.
//

import UIKit
import WebKit

class RepoWebViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    public var url = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(backTapped(sender:)))
        // Do any additional setup after loading the view.
        
        if !url.isEmpty {
            if let uurl = URL(string: url) {
                webView.load(URLRequest(url: uurl))
            }
        }
    }
    @objc func backTapped(sender: UIBarButtonItem) {
        if let vc = navigationController?.viewControllers[1] {
            if vc != self {
                navigationController?.popToViewController(vc, animated: true)
            }
        }
        navigationController?.popViewController(animated: true)
    }

}
