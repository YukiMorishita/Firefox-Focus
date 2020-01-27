//
//  MozillaSupportViewController.swift
//  Firefox Focus
//
//  Created by admin on 2020/01/18.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import WebKit

class MozillaSupportController: UIViewController {
    
    var urlString: String? {
        didSet {
            guard let urlString = urlString else { return }
            
            let url = URL(string: urlString)!
            
            let request = URLRequest(url: url)
            webView.load(request)
            
            loadIndicator.startAnimating()
        }
    }
    
    fileprivate let webView: WKWebView = {
        let wv = WKWebView()
        wv.translatesAutoresizingMaskIntoConstraints = false
        wv.alpha = 0
        return wv
    }()
    
    fileprivate let loadIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .white
        indicator.style = .large
        return indicator
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "background1")
        
        setupLoadIndicator()
        setupWebView()
        
        webView.navigationDelegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        webView.stopLoading()
    }
    
    fileprivate func setupWebView() {
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leftAnchor.constraint(equalTo: view.leftAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    fileprivate func setupLoadIndicator() {
        view.addSubview(loadIndicator)
        
        NSLayoutConstraint.activate([
            loadIndicator.topAnchor.constraint(equalTo: view.topAnchor),
            loadIndicator.leftAnchor.constraint(equalTo: view.leftAnchor),
            loadIndicator.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadIndicator.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
}

// MARK: - WKNavigationDelegate

extension MozillaSupportController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        UIView.animate(withDuration: 0.4, animations: {
            self.webView.alpha = 1.0
        }, completion: { finished in
            self.loadIndicator.stopAnimating()
        })
    }
}
