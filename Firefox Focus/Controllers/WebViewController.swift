//
//  WebViewController.swift
//  Firefox Focus
//
//  Created by admin on 2020/01/15.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import WebKit

class WebController: UIViewController {
    
    private var suggestions = [Suggestion]()
    
    private var navigationBarHeightConstraint: NSLayoutConstraint!
    private var progressViewRightConstraint: NSLayoutConstraint!
    private var toolBarBottomConstraint: NSLayoutConstraint!
    
    private let statusBarHeight = UIApplication.shared.statusBar?.frame.height ?? 0
    private let safeAreaBottom = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
    private let navigationBarHeight: CGFloat = 66.0
    private let toolBarHeight: CGFloat = 49.0
    private let rowHeight: CGFloat = 56.0
    
    private let cellId = "cellId"
    
    private var startContentOffsetY: CGFloat = 0.0
    
    var url: URL? {
        didSet {
            guard let url = url else { return }
            let request = URLRequest(url: url)
            webView.load(request)
            
            let domain = url.host
            navigationBar.searchBar.text = domain
        }
    }
    
    private lazy var navigationBar: MainNavigationBar = {
        let navBar = MainNavigationBar(mode: .result)
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.delegate = self
        return navBar
    }()
    
    private let progressView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let colors = [UIColor(named: "button")?.cgColor, UIColor(named: "gradient2")?.cgColor] as! [CGColor]
        let size = CGSize(width: UIScreen.main.bounds.width, height: 4.0)
        view.backgroundColor = .gradientColor(colors: colors, size: size, startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1, y: 1))
        view.layer.cornerRadius = 4.0 / 2
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var toolBar: MainToolBar = {
        let toolBar = MainToolBar(mode: .result)
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        toolBar.delegate = self
        return toolBar
    }()
    
    private lazy var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.websiteDataStore = .nonPersistent()
        webConfiguration.allowsInlineMediaPlayback = true
        let wv = WKWebView(frame: .zero, configuration: webConfiguration)
        wv.translatesAutoresizingMaskIntoConstraints = false
        wv.allowsBackForwardNavigationGestures = true
        wv.scrollView.delegate = self
        wv.navigationDelegate = self
        wv.uiDelegate = self
        return wv
    }()
    
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor(white: 0, alpha: 0.7)
        tv.tableFooterView = UIView(frame: .zero)
        tv.separatorStyle = .none
        tv.alpha = 0.0
        tv.isScrollEnabled = false
        tv.showsVerticalScrollIndicator = false
        tv.register(SuggestionCell.self, forCellReuseIdentifier: self.cellId)
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let colors = [UIColor(named: "gradient1")?.cgColor, UIColor(named: "gradient2")?.cgColor, UIColor(named: "gradient3")?.cgColor] as! [CGColor]
        self.view.backgroundColor = UIColor.gradientColor(colors: colors, size: view.frame.size, startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1, y: 1))
        
        setupNavigationBar()
        setupToolBar()
        setupWebView()
        setupProgressView()
        setupTableView()
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

        if keyPath == "estimatedProgress" {
            let total = view.frame.width + view.frame.width / 3.0
            let percentage: CGFloat = CGFloat(webView.estimatedProgress * Double(total)).rounded()
            progressViewRightConstraint.constant = percentage
            
            UIView.animate(withDuration: 0.4) {
                self.view.layoutIfNeeded()
            }
            
            if webView.estimatedProgress == 1.0 {
                // Hide progress view
                UIView.animate(withDuration: 0, delay: 0.4, options: .curveLinear, animations: {
                    self.progressView.alpha = 0.0
                }, completion: nil)

                progressViewRightConstraint.constant = 0

                // Reset progress view position
                UIView.animate(withDuration: 0.2, delay: 0.4, options: .curveLinear, animations: {
                    self.view.layoutIfNeeded()
                }, completion: { completed in
                    // Show progress view
                    self.progressView.alpha = 1.0
                })
            }
        }
    }
    
    fileprivate func setupNavigationBar() {
        view.addSubview(navigationBar)
        
        let height = statusBarHeight + navigationBarHeight
        navigationBarHeightConstraint = navigationBar.heightAnchor.constraint(equalToConstant: height)
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.topAnchor),
            navigationBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            navigationBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            navigationBarHeightConstraint
        ])
    }
    
    fileprivate func setupProgressView() {
        view.addSubview(progressView)
        
        progressViewRightConstraint = progressView.rightAnchor.constraint(equalTo: view.leftAnchor)
        
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            progressView.leftAnchor.constraint(equalTo: progressView.rightAnchor, constant: -view.frame.width / 3.0),
            progressViewRightConstraint,
            progressView.heightAnchor.constraint(equalToConstant: 4.0)
        ])
    }
    
    fileprivate func setupToolBar() {
        view.addSubview(toolBar)
        
        toolBarBottomConstraint = toolBar.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        NSLayoutConstraint.activate([
            toolBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            toolBarBottomConstraint,
            toolBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            toolBar.heightAnchor.constraint(equalToConstant: safeAreaBottom + toolBarHeight)
        ])
    }
    
    fileprivate func setupWebView() {
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            webView.leftAnchor.constraint(equalTo: view.leftAnchor),
            webView.bottomAnchor.constraint(equalTo: toolBar.topAnchor),
            webView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    fileprivate func setupTableView() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(handleHideKeyboard))
        tapGesture.delegate = self
        tableView.addGestureRecognizer(tapGesture)
    }
    
    fileprivate func beginSearch() {
        UIView.animate(withDuration: 0.2) {
            self.navigationBar.changeMode(mode: .searching)
            self.tableView.alpha = 1.0
        }
    }
    
    fileprivate func endSearch() {
        UIView.animate(withDuration: 0.2) {
            self.navigationBar.changeMode(mode: .result)
            self.tableView.alpha = 0.0
        }
    }
    
    fileprivate func hideKeyboardAndClearTextField() {
        navigationBar.searchBar.clearTextField()
        navigationBar.searchBar.resignFirstResponder()
    }
    
    fileprivate func reloadTable() {
        tableView.reloadData()
    }
    
    @objc func handleHideKeyboard() {
        self.hideKeyboardAndClearTextField()
    }
}

extension WebController: MainNavigationBarDelegate {
    
    func didSearchCancel() {
        self.hideKeyboardAndClearTextField()
    }
    
    func didTrackingProtection() {
        
    }
    
    func didBrowsingHistoryErased() {
        self.modalTransitionStyle = .coverVertical
        self.dismiss(animated: true, completion: nil)
    }
    
    func didMoreAction() {
        
    }
    
    func didBeginSearch() {
        self.beginSearch()
    }
    
    func didEndSearch() {
        self.endSearch()
    }
    
    func didChangeSearchText(searchText: String) {
        self.beginSearch()
    }
    
    func didSearch(searchText: String) {
        
    }
}

extension WebController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SuggestionCell
        let suggestion = suggestions[indexPath.row]
        cell.suggestion = suggestion
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension WebController: MainToolBarDelegate {
    
    func didGoBack() {
        webView.goBack()
    }
    
    func didGoForward() {
        webView.goForward()
    }
    
    func didRefresh() {
        webView.reload()
    }
    
    func didSettings() {
        let settingsController = UINavigationController(rootViewController: SettingsController(style: .grouped))
        settingsController.modalPresentationStyle = .fullScreen
        present(settingsController, animated: true, completion: nil)
    }
}

extension WebController: WKNavigationDelegate, WKUIDelegate {
    
    // MARK: - WKNavigationDelegate
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        let canGoBack = webView.canGoBack
        toolBar.setGoBackButtonIsEnable(canGoBack, animated: true)
        
        let canGoForward = webView.canGoForward
        toolBar.setGoForwardIsEnabled(canGoForward, animated: true)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("unvalid url")
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print(navigationAction.request)
        decisionHandler(.allow)
    }
    
    // MARK: - WKUIDelegate
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        if navigationAction.targetFrame == nil {
            guard let link = navigationAction.request.url else {
                return nil
            }
            let domain = link.host
            navigationBar.searchBar.text = domain
            
            webView.load(navigationAction.request)
        }
        return nil
    }
}

extension WebController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        self.startContentOffsetY = contentOffsetY
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let upperLimit: CGFloat = 0.0
        let lowerLimit: CGFloat = -30.0
        let contentOffsetY = scrollView.contentOffset.y
        let distance = max(min(startContentOffsetY - contentOffsetY, upperLimit), lowerLimit)
        
        if distance <= 0.0 && navigationBarHeightConstraint.constant <= 80.0 {
            return
        }
        
        let heightConstant = distance + CGFloat(statusBarHeight + navigationBarHeight)
        navigationBarHeightConstraint.constant = heightConstant.rounded()
        
        let bottomConstant = (min(-distance, 30.0) / 30.0) * toolBar.frame.height
        toolBarBottomConstraint.constant = bottomConstant.rounded()
        
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y < 0 {
            navigationBarHeightConstraint.constant = statusBarHeight + navigationBarHeight
            toolBarBottomConstraint.constant = 0
            
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    private func caluculatePercentage(_ num: Double, total: Double) -> Double {
        let percentage = (num / total) * 100.0
        return percentage.rounded()
    }
}

extension WebController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if tableView.indexPathForRow(at: touch.location(in: tableView)) != nil {
            return false
        }
        return true
    }
}
