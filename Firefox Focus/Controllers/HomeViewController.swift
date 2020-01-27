//
//  HomeViewController.swift
//  Firefox Focus
//
//  Created by admin on 2020/01/15.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class HomeController: UIViewController {
    
    private var suggestions = [Suggestion]()
    
    private let statusBarHeight = UIApplication.shared.statusBar?.frame.height ?? 0
    private let safeAreaBottom = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
    private let navigationBarHeight: CGFloat = 66.0
    private let toolBarHeight: CGFloat = 49.0
    private let rowHeight: CGFloat = 56.0
    
    private let cellId = "cellId"
    
    let logoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let attributedText = NSMutableAttributedString(string: "Firefox Focus\n", attributes: [.foregroundColor: UIColor(named: "title")!, .font: UIFont(name: "PTSans-NarrowBold", size: 36)!])
        attributedText.append(NSAttributedString(string: "Automatic private browsing.\n Browser. Erase. Repeat.", attributes: [.foregroundColor: UIColor(named: "subtitle")!, .font: UIFont(name: "OpenSans-Regular", size: 14)!]))
        label.attributedText = attributedText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let toolBar: MainToolBar = {
        let toolBar = MainToolBar(mode: .normal)
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        return toolBar
    }()
    
    private let navigationBar: MainNavigationBar = {
        let navbar = MainNavigationBar(mode: .normal)
        navbar.translatesAutoresizingMaskIntoConstraints = false
        return navbar
    }()
    
    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor(white: 0, alpha: 0.7)
        tv.tableFooterView = UIView(frame: .zero)
        tv.separatorStyle = .none
        tv.alpha = 0.0
        tv.isScrollEnabled = false
        tv.showsVerticalScrollIndicator = false
        return tv
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let colors = [UIColor(named: "gradient1")?.cgColor, UIColor(named: "gradient2")?.cgColor, UIColor(named: "gradient3")?.cgColor] as! [CGColor]
        self.view.backgroundColor = UIColor.gradientColor(colors: colors, size: view.frame.size, startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1, y: 1))
        
        setupLogoLabelView()
        setupToolBar()
        setupNavigationBar()
        setupTableView()
        setupKeyboardObservers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationBar.searchBar.becomeFirstResponder()
    }
    
    fileprivate func setupLogoLabelView() {
        view.addSubview(logoLabel)
        
        NSLayoutConstraint.activate([
            logoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    fileprivate func setupToolBar() {
        view.addSubview(toolBar)
        
        NSLayoutConstraint.activate([
            toolBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            toolBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            toolBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            toolBar.heightAnchor.constraint(equalToConstant: safeAreaBottom + toolBarHeight)
        ])
        
        toolBar.delegate = self
    }
    
    fileprivate func setupNavigationBar() {
        view.addSubview(navigationBar)
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.topAnchor),
            navigationBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            navigationBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: statusBarHeight + navigationBarHeight)
        ])
        
        navigationBar.delegate = self
    }
    
    fileprivate func setupTableView() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
        tableView.register(SuggestionCell.self, forCellReuseIdentifier: cellId)
        tableView.delegate = self
        tableView.dataSource = self
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(handleHideKeyboard))
        tapGesture.delegate = self
        
        tableView.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleHideKeyboard() {
        self.hideKeyboardAndClearTextField()
    }
    
    fileprivate func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func handleKeyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        
        let logoLabelY = (keyboardFrame.height + toolBarHeight - navigationBarHeight) / 2
        let logoLabelTransform = CGAffineTransform(translationX: 0, y: -logoLabelY)
        
        let toolBarY = keyboardFrame.height - safeAreaBottom
        let toolBarTransform = CGAffineTransform(translationX: 0, y: -toolBarY)
        
        UIView.animate(withDuration: duration) {
            self.logoLabel.transform = logoLabelTransform
            self.toolBar.transform = toolBarTransform
        }
    }
    
    @objc func handleKeyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        
        UIView.animate(withDuration: duration) {
            self.logoLabel.transform = .identity
            self.toolBar.transform = .identity
        }
    }
    
    fileprivate func beginSearch() {
        UIView.animate(withDuration: 0.2) {
            self.navigationBar.changeMode(mode: .searching)
            self.tableView.alpha = 1.0
        }
    }
    
    fileprivate func endSearch() {
        UIView.animate(withDuration: 0.2) {
            self.navigationBar.changeMode(mode: .normal)
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
    
    fileprivate func showWebController(url: URL?) {
        let webController = WebController()
        webController.url = url
        webController.modalPresentationStyle = .fullScreen
        webController.modalTransitionStyle = .crossDissolve
        present(webController, animated: true, completion: nil)
    }
}

extension HomeController: MainToolBarDelegate {
    
    func didGoBack() {}
    
    func didGoForward() {}
    
    func didRefresh() {}
    
    func didSettings() {
        let settingsController = UINavigationController(rootViewController: SettingsController(style: .grouped))
        settingsController.modalPresentationStyle = .fullScreen
        present(settingsController, animated: true, completion: nil)
    }
}

extension HomeController: MainNavigationBarDelegate {

    func didSearchCancel() {
        self.hideKeyboardAndClearTextField()
    }
    
    func didTrackingProtection() {}
    
    func didBrowsingHistoryErased() {}
    
    func didMoreAction() {}
    
    func didBeginSearch() {
        self.beginSearch()
    }
    
    func didEndSearch() {
        self.endSearch()
    }
    
    func didChangeSearchText(searchText: String) {
        if searchText == "" {
            suggestions.removeAll()
            reloadTable()
            return
        }
        
        let engine = SearchEngine(type: .google)
        let searchEngineSuggestion = SearchEngineSuggestionSource(engine: engine)
        searchEngineSuggestion.generataSuggestion(search: searchText) { (suggestions) in
            self.suggestions = suggestions
            
            DispatchQueue.main.async {
                self.reloadTable()
            }
        }
    }
    
    func didSearch(searchText: String) {
        let engine = SearchEngine(type: .google)
        let url = engine.url(for: searchText)
        self.showWebController(url: url)
        self.endSearch()
    }
}

extension HomeController: UITableViewDelegate, UITableViewDataSource {
    
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
        let suggestion = suggestions[indexPath.row]
        let url = suggestion.url
        self.showWebController(url: url)
        self.endSearch()
    }
}

extension HomeController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if tableView.indexPathForRow(at: touch.location(in: tableView)) != nil {
            return false
        }
        return true
    }
}

//// MARK: - HomeViewDelegate
//
//extension HomeController: HomeViewDelegate {
//
//    func didHideKeyboard() {
//        isSearch = false
//        homeView.changedNavigationType(.normal)
//
//        // Search bar resign first responder and clear textfield text
//        homeView.mainNavigationBar.searchBarCrearTextField()
//    }
//}
//
//// MARK: - MainNavigationBarDelegate
//
//extension HomeController: MainNavigationBarDelegate {
//
//    func didSeachCancel() {
//        isSearch = false
//        homeView.changedNavigationType(.normal)
//
//        homeView.mainNavigationBar.searchBarCrearTextField()
//    }
//
//    func didTrackingProtection() {}
//
//    func didBrowsingHistoryErased() {}
//
//    func didMoreAction() {}
//}
//
//// MARK: - MainToolBarDelegate
//
//extension HomeController: MainToolBarDelegate {
//
//    func didGoBack() {}
//
//    func didGoForward() {}
//
//    func didRefresh() {}
//
//    func didSettings() {
//        // Show settings controller
//        let settingsController = UINavigationController(rootViewController: SettingsController(style: .grouped))
//        settingsController.modalPresentationStyle = .fullScreen
//        present(settingsController, animated: true, completion: nil)
//    }
//}
//
//// MARK: - UISearchBarDelegate
//
//extension HomeController: UISearchBarDelegate {
//
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
////        if !isSearch {
////            isSearch = true
////            homeView.changedNavigationType(.search)
////        }
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if !isSearch {
//            isSearch = true
//            homeView.changedNavigationType(.search)
//
//            // Customozed clear button
//            let clearButton = homeView.mainNavigationBar.mainSearchBar.textField?.value(forKey: "_clearButton") as? UIButton
//            clearButton?.alpha = 0.0
//            clearButton?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
//
//            UIView.animate(withDuration: 0.2, delay: 0.3, options: .curveLinear, animations: {
//                clearButton?.alpha = searchText.isEmpty ? 0.0 : 1.0
//            }, completion: nil)
//        }
//
//        // Any process
//    }
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        // Search text with blanks removed
//        guard let searchText = searchBar.text?.lowercased().trimmingCharacters(in: .whitespaces) else { return }
//
//        if !searchText.isEmpty {
//            var url = URL(string: searchText)
//
//            if !["http", "https"].contains(url?.scheme?.lowercased()) {
//                let editedUrl = URL(string: "http://".appending(searchText))
//                url = editedUrl
//            }
//
//            // Hide keyboard
//            searchBar.resignFirstResponder()
//
//            // Show WebController
//            let webController = WebController()
//            webController.url = url
//            webController.modalPresentationStyle = .fullScreen
//            webController.modalTransitionStyle = .crossDissolve
//            present(webController, animated: true, completion: nil)
//        }
//    }
//}
//
//extension HomeController: UITableViewDelegate, UITableViewDataSource {
//
//    // MARK: - UITableViewDataSource
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 5
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SearchSuggestionCell
//
//        let searchSuggestion = "\(indexPath.item): item"
//        cell.searchSuggestion = searchSuggestion
//
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 56
//    }
//
//    // MARK: - UITableViewDelegate
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath.item)
//    }
//}
//
//// MARK: - UIGestureRecognizerDelegate
//
//extension HomeController: UIGestureRecognizerDelegate {
//
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        // Disable tap gesture if indexpath can be obtained
//        if homeView.tableView.indexPathForRow(at: touch.location(in: homeView.tableView)) != nil {
//            return false
//        }
//        return true
//    }
//}
