//
//  SettingsViewController.swift
//  Firefox Focus
//
//  Created by admin on 2020/01/18.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class SettingsController: UITableViewController {
    
    private let sectionTitles = ["PRIVACY", "SEARCH", "SIRI SHORTCUTS", "SAFARI INTEGRATION", "MOZILLA"]
    
    private let sectionData = [
        [
            Setting(title: "Tracking Protection", description: "", cellStyle: .normal, accessoryType: .disclosureIndicator),
            Setting(title: "Block Web fonts", description: "", cellStyle: .normal, accessoryType: .stateSwitch),
            Setting(title: "Use Face ID to unlock app", description: "Face ID can unlock Firefox Focus if a URL is already open in the app.", cellStyle: .custom, accessoryType: .stateSwitch),
            Setting(title: "Send usage data", description: "Mozilla strives to collect only what we need to provide and improve Firefox Focus for everyone.", cellStyle: .custom, accessoryType: .stateSwitch)
        ],
        [
            Setting(title: "Search Engine", description: "Google", cellStyle: .normal, accessoryType: .disclosureIndicator),
            Setting(title: "URL Autocomplete", description: "Enabled", cellStyle: .normal, accessoryType: .disclosureIndicator),
            Setting(title: "Get Search Suggestions", description: "Firefox Focus will send what you type in the address bar to your search engine.", cellStyle: .custom, accessoryType: .stateSwitch)
        ],
        [
            Setting(title: "Erase", description: "Add to Siri", cellStyle: .normal, accessoryType: .disclosureIndicator),
            Setting(title: "Erase & Open", description: "Add to Siri", cellStyle: .normal, accessoryType: .disclosureIndicator),
            Setting(title: "Open Favorite Site", description: "Add", cellStyle: .normal, accessoryType: .disclosureIndicator)
        ],
        [
            Setting(title: "Safari", description: "", cellStyle: .normal, accessoryType: .stateSwitch)
        ],
        [
            Setting(title: "About Firefox Focus", description: "", cellStyle: .normal, accessoryType: .none),
            Setting(title: "Rate Firefox Focus", description: "", cellStyle: .normal, accessoryType: .none)
        ]
    ]
    
    private let cellId = "cellId"
    private let customCellId = "customCellId"
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItems()
        setupTableView()
        
        extendedLayoutIncludesOpaqueBars = true
    }
    
    fileprivate func setupTableView() {
        tableView.backgroundColor = UIColor(named: "background1")
        tableView.separatorColor = .darkGray
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.register(SettingCell.self, forCellReuseIdentifier: customCellId)
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionData[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let setting = sectionData[indexPath.section][indexPath.item]
        
        switch setting.cellStyle {
        case .normal:
            // CellStyle: .value1 = .rightDetail
            let cell = UITableViewCell(style: .value1, reuseIdentifier: cellId)
            cell.backgroundColor = UIColor(named: "background2")
            cell.textLabel?.text = setting.title
            cell.detailTextLabel?.text = setting.description
            cell.textLabel?.textColor = UIColor(named: "onBackground")
            cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
            
            let lightGrayView = UIView(frame: cell.bounds)
            lightGrayView.backgroundColor = UIColor(white: 1.0, alpha: 0.2)
            cell.selectedBackgroundView = lightGrayView
            
            switch setting.accessoryType {
            case .none:
                cell.accessoryType = .none
            case .stateSwitch:
                let stateSwitch = UISwitch()
                stateSwitch.onTintColor = UIColor(named: "switch")
                stateSwitch.isOn = loadStateSwitchValue(indexPath: indexPath)
                stateSwitch.addTarget(self, action: #selector(handleStateSwitchValueChanged(_:)), for: .valueChanged)
                
                cell.accessoryView = stateSwitch
                cell.selectionStyle = .none
                
            case .disclosureIndicator:
                let disclosureIndicatorImageView = UIImageView()
                disclosureIndicatorImageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
                disclosureIndicatorImageView.tintColor = .lightGray
                disclosureIndicatorImageView.image = UIImage(named: "disclosureIndicator")?.withRenderingMode(.alwaysTemplate)
                disclosureIndicatorImageView.contentMode = .scaleAspectFill
                disclosureIndicatorImageView.clipsToBounds = true
                
                cell.accessoryView = disclosureIndicatorImageView
                cell.selectionStyle = .gray
            }
            
            return cell
            
        case .custom:
            let cell = tableView.dequeueReusableCell(withIdentifier: customCellId, for: indexPath) as! SettingCell
            cell.setting = setting
            cell.delegate = self
            
            switch setting.accessoryType {
            case .none:
                cell.accessoryType = .none
            case .stateSwitch:
                let stateSwitch = UISwitch()
                stateSwitch.onTintColor = UIColor(named: "switch")
                stateSwitch.isOn = loadStateSwitchValue(indexPath: indexPath)
                stateSwitch.addTarget(self, action: #selector(handleStateSwitchValueChanged(_:)), for: .valueChanged)
                
                cell.accessoryView = stateSwitch
                cell.selectionStyle = .none
                
            case .disclosureIndicator:
                let disclosureIndicatorImageView = UIImageView()
                disclosureIndicatorImageView.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
                disclosureIndicatorImageView.tintColor = .lightGray
                disclosureIndicatorImageView.image = UIImage(named: "disclosureIndicator")?.withRenderingMode(.alwaysTemplate)
                disclosureIndicatorImageView.contentMode = .scaleAspectFill
                disclosureIndicatorImageView.clipsToBounds = true
                
                cell.accessoryView = disclosureIndicatorImageView
            }
            
            let section = indexPath.section
            let row = indexPath.row
            
            if section == 0 && row == 2 {
                cell.setLearnMoreButtonIsHidden(true)
            } else {
                cell.setLearnMoreButtonIsHidden(false)
            }
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 && row == 0 {
            // Show TrackingProtectionController
            let trackingProtectionController = TrackingProtectionController(style: .grouped)
            navigationController?.pushViewController(trackingProtectionController, animated: true)
        }
        
        if section == 4 && row == 0 {
            let aboutController = AboutController(style: .grouped)
            navigationController?.pushViewController(aboutController, animated: true)
        }
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
            let section = indexPath.section
            let row = indexPath.row
            
            //if section == 0 && row == 1 {
            
            saveStateSwitchValue(sender.isOn, indexPath: indexPath)
        }
    }
}

extension SettingsController {
    
    private func setupNavigationItems() {
        setupRemainingNavItems()
        setupLeftNavItem()
        setupRightNavItem()
    }
    
    private func setupRemainingNavItems() {
        navigationItem.title = "Settings"
        
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor(named: "title")!]
        navigationController?.navigationBar.barTintColor = UIColor(named: "background2")
        navigationController?.navigationBar.tintColor = UIColor(named: "onBackground")
        navigationController?.navigationBar.isTranslucent = false
    }
    
    private func setupLeftNavItem() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
        doneButton.tintColor = UIColor(named: "button")
        navigationItem.leftBarButtonItem = doneButton
    }
    
    private func setupRightNavItem() {
        let whatsNewButton = UIBarButtonItem(image: #imageLiteral(resourceName: "what's_new"), style: .done, target: self, action: #selector(handleWhatsNew))
        navigationItem.rightBarButtonItem = whatsNewButton
    }
    
    // MARK: - UIBarButton Handling
    
    @objc func handleDone() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleWhatsNew() {
        let mozillaSupportController = MozillaSupportController()
        mozillaSupportController.urlString = "https://support.mozilla.org/mk/kb/whats-new-firefox-focus-ios-version-8"
        navigationController?.pushViewController(mozillaSupportController, animated: true)
    }
}

extension SettingsController: SettingCellDelegate {
    
    func didLearnMore(cell: SettingCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let section = indexPath.section
            let row = indexPath.row
            
            let mozillaSupportController = MozillaSupportController()
            
            if section == 0 && row == 3 {
                mozillaSupportController.urlString = "https://support.mozilla.org/en-US/kb/send-usage-data-firefox-mobile-browsers"
            }
            
            if section == 1 && row == 2 {
                mozillaSupportController.urlString = "https://support.mozilla.org/en-US/kb/search-suggestions-firefox-focus-ios"
            }
            
            navigationController?.pushViewController(mozillaSupportController, animated: true)
        }
    }
}
