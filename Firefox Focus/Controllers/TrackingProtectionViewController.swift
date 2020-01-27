//
//  TrackingProtectionViewController.swift
//  Firefox Focus
//
//  Created by admin on 2020/01/18.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class TrackingProtectionController: UITableViewController {
    
    private let cellData = [
        TrackingProtection(title: "Block ad Trackers", description: "Some ads track site visits, even if you don't click the ads"),
        TrackingProtection(title: "Block analystics trackers", description: "Used to collect, analyze and measure activities like tapping and scrolling"),
        TrackingProtection(title: "Block social trackers", description: "Embedded on sites to track your visits and to display functionality like share buttons"),
        TrackingProtection(title: "Block other content trackers", description: "Enabling may cause some pages to behave unexpectedly")
    ]
    
    private let cellId = "cellId"
    private let footerId = "footerId"
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Tracking Protection"
        
        setupTableView()
    }
    
    fileprivate func setupTableView() {
        tableView.backgroundColor = UIColor(named: "background1")
        tableView.separatorColor = .darkGray
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.estimatedSectionFooterHeight = UITableView.automaticDimension
        tableView.register(TrackingProtectionCell.self, forCellReuseIdentifier: cellId)
        tableView.register(TrackingProtectionFooterView.self, forHeaderFooterViewReuseIdentifier: footerId)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TrackingProtectionCell
        cell.selectionStyle = .none
        
        let dataSourceItem = cellData[indexPath.row]
        cell.dataSourceItem = dataSourceItem
        
        let stateSwitch = UISwitch()
        stateSwitch.isOn = loadStateSwitchValue(indexPath: indexPath)
        stateSwitch.onTintColor = UIColor(named: "switch")
        stateSwitch.addTarget(self, action: #selector(handleStateSwitchValueChanged(_:)), for: .valueChanged)
        
        cell.accessoryView = stateSwitch
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: footerId) as! TrackingProtectionFooterView
        footerView.delegate = self
        return footerView
    }
    
    fileprivate func loadStateSwitchValue(indexPath: IndexPath) -> Bool {
        let defaults = UserDefaults.standard
        let value = defaults.bool(forKey: indexPath.description)
        return value
    }
    
    fileprivate func saveStateSwitchValue(_ value: Bool, indexPath: IndexPath) {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: indexPath.description)
    }
    
    // MARK: - UISwitch Handling
    
    @objc func handleStateSwitchValueChanged(_ sender: UISwitch) {
        let point = sender.convert(sender.bounds.origin, to: tableView)
        
        if let indexPath = tableView.indexPathForRow(at: point) {
            saveStateSwitchValue(sender.isOn, indexPath: indexPath)
        }
    }
}

extension TrackingProtectionController: TrackingProtectionFooterViewDelegate {
    
    func didLearnMore() {
        let mozillaSupportController = MozillaSupportController()
        mozillaSupportController.urlString = "https://support.mozilla.org/en-US/kb/tracking-protection-focus-ios"
        navigationController?.pushViewController(mozillaSupportController, animated: true)
    }
}
