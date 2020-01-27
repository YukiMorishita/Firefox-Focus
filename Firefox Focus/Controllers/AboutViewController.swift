//
//  AboutViewController.swift
//  Firefox Focus
//
//  Created by admin on 2020/01/19.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class AboutController: UITableViewController {
    
    private let cellData = ["Help", "Your Rights", "Privacy Notice"]
    
    private let cellId = "cellId"
    private let headerId = "headerId"
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "About Firefox Focus"
        
        setupTableView()
    }
    
    fileprivate func setupTableView() {
        tableView.backgroundColor = UIColor(named: "background1")
        tableView.separatorColor = .darkGray
        tableView.separatorInset = .zero
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(AboutHeaderView.self, forHeaderFooterViewReuseIdentifier: headerId)
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: cellId)
        cell.backgroundColor = UIColor(named: "background1")
        cell.textLabel?.text = cellData[indexPath.row]
        cell.textLabel?.textColor = UIColor(named: "onBackground")
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        
        let lightGrayView = UIView()
        lightGrayView.frame = cell.bounds
        lightGrayView.backgroundColor = UIColor(white: 1.0, alpha: 0.2)
        cell.selectedBackgroundView = lightGrayView
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as! AboutHeaderView
        headerView.delegate = self
        return headerView
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mozillaSupportController = MozillaSupportController()
        
        if indexPath.row == 0 {
            mozillaSupportController.urlString = "https://support.mozilla.org/en-US/kb/focus"
        }
        
        if indexPath.row == 1 {
            // any process
        }
        
        if indexPath.row == 2 {
            mozillaSupportController.urlString = "https://www.mozilla.org/en-US/privacy/firefox-focus/"
        }
        
        navigationController?.pushViewController(mozillaSupportController, animated: true)
    }
}

extension AboutController: AboutHeaderViewDelegate {
    
    func didLearnMore() {
        let mozillaSupportController = MozillaSupportController()
        mozillaSupportController.urlString = "https://www.mozilla.org/en-US/about/manifesto/"
        navigationController?.pushViewController(mozillaSupportController, animated: true)
    }
}
