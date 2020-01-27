//
//  MainNavigationBar.swift
//  Firefox Focus
//
//  Created by admin on 2020/01/21.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

enum NavigationMode {
    case normal
    case searching
    case result
    case minimal
}

protocol MainNavigationBarDelegate: class {
    func didSearchCancel()
    func didTrackingProtection()
    func didBrowsingHistoryErased()
    func didMoreAction()
    func didBeginSearch()
    func didEndSearch()
    func didChangeSearchText(searchText: String)
    func didSearch(searchText: String)
}

class MainNavigationBar: UIView {
    
    weak var delegate: MainNavigationBarDelegate?
    
    var searchBarLeftConstraint: NSLayoutConstraint!
    var searchBarRightConstraint: NSLayoutConstraint!
    
    let searchBar: MainSearchBar = {
        let sb = MainSearchBar()
        sb.translatesAutoresizingMaskIntoConstraints = false
        return sb
    }()
    
    lazy var searchCancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "goBack"), for: .normal)
        button.alpha = 0.0
        button.addTarget(self, action: #selector(handleSearchCancel), for: .touchUpInside)
        return button
    }()
    
    lazy var trackingProtectionButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "security"), for: .normal)
        button.alpha = 0.0
        button.addTarget(self, action: #selector(handleTrackingProtection), for: .touchUpInside)
        return button
    }()
    
    lazy var browsingHistoryErasedButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "delete"), for: .normal)
        button.alpha = 0.0
        button.addTarget(self, action: #selector(handleBrowsingHistoreErased), for: .touchUpInside)
        return button
    }()
    
    let secureWebsiteImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    lazy var moreActionButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleMoreAction), for: .touchUpInside)
        return button
    }()
    
    init(mode: NavigationMode) {
        super.init(frame: .zero)
        setupViews()
        switch mode {
        case .normal:       self.normalMode()
        case .searching:    self.searchingMode()
        case .result:       self.resultMode()
        case .minimal:      self.minimalMode()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(searchCancelButton)
        addSubview(trackingProtectionButton)
        addSubview(browsingHistoryErasedButton)
        addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchCancelButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 4),
            searchCancelButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            searchCancelButton.widthAnchor.constraint(equalToConstant: 50),
            searchCancelButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            trackingProtectionButton.leftAnchor.constraint(equalTo: searchCancelButton.leftAnchor),
            trackingProtectionButton.bottomAnchor.constraint(equalTo: searchCancelButton.bottomAnchor),
            trackingProtectionButton.widthAnchor.constraint(equalToConstant: 50),
            trackingProtectionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            browsingHistoryErasedButton.bottomAnchor.constraint(equalTo: searchCancelButton.bottomAnchor),
            browsingHistoryErasedButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -8),
            browsingHistoryErasedButton.widthAnchor.constraint(equalToConstant: 50),
            browsingHistoryErasedButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        searchBarLeftConstraint = searchBar.leftAnchor.constraint(equalTo: leftAnchor, constant: 8)
        searchBarRightConstraint = searchBar.rightAnchor.constraint(equalTo: rightAnchor, constant: -8)
        
        NSLayoutConstraint.activate([
            searchBarLeftConstraint,
            searchBar.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            searchBarRightConstraint,
            searchBar.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        searchBar.delegate = self
    }
    
    func changeMode(mode: NavigationMode) {
        switch mode {
        case .normal:       self.normalMode()
        case .searching:    self.searchingMode()
        case .result:       self.resultMode()
        case .minimal:      self.minimalMode()
        }
    }
    
    func normalMode() {
        self.backgroundColor = .clear
        self.searchCancelButton.alpha = 0.0
        self.trackingProtectionButton.alpha = 0.0
        self.browsingHistoryErasedButton.alpha = 0.0
        self.moreActionButton.alpha = 0.0
        self.searchBar.changeMode(.normal)
        self.searchBarLeftConstraint.constant = 8
        self.searchBarRightConstraint.constant = -8
        self.layoutIfNeeded()
    }
    
    func searchingMode() {
        self.backgroundColor = UIColor(named: "background1")?.withAlphaComponent(0.9)
        self.searchCancelButton.alpha = 1.0
        self.trackingProtectionButton.alpha = 0.0
        self.browsingHistoryErasedButton.alpha = 0.0
        self.moreActionButton.alpha = 0.0
        self.searchBar.changeMode(.normal)
        self.searchBarLeftConstraint.constant = 58
        self.searchBarRightConstraint.constant = -8
        self.layoutIfNeeded()
    }
    
    func resultMode() {
        let colors = [UIColor(named: "gradient1")?.cgColor, UIColor(named: "gradient2")?.cgColor, UIColor(named: "gradient3")?.cgColor] as! [CGColor]
        let statusBarHeight: CGFloat = UIApplication.shared.statusBar?.frame.height ?? 0
        let height: CGFloat = 66.0
        let size = CGSize(width: UIScreen.main.bounds.width, height: statusBarHeight + height)
        self.backgroundColor = .gradientColor(colors: colors, size: size, startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1, y: 1))
        self.searchCancelButton.alpha = 0.0
        self.trackingProtectionButton.alpha = 1.0
        self.browsingHistoryErasedButton.alpha = 1.0
        self.moreActionButton.alpha = 1.0
        self.searchBar.changeMode(.result)
        self.searchBarLeftConstraint.constant = 58
        self.searchBarRightConstraint.constant = -58
        self.layoutIfNeeded()
    }
    
    func minimalMode() {
        self.searchBar.alpha = 0.0
        self.trackingProtectionButton.alpha = 0.0
        self.browsingHistoryErasedButton.alpha = 0.0
    }
    
    // MARK: - UIButton Handling
    
    @objc func handleSearchCancel() {
        delegate?.didSearchCancel()
    }
    
    @objc func handleBrowsingHistoreErased() {
        delegate?.didBrowsingHistoryErased()
    }
    
    @objc func handleTrackingProtection() {
        delegate?.didTrackingProtection()
    }
    
    @objc func handleMoreAction() {
        delegate?.didMoreAction()
    }
}

extension MainNavigationBar: UISearchBarDelegate {
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        delegate?.didEndSearch()
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let removeWhiteSpacesText = searchText.lowercased().trimmingCharacters(in: .whitespaces)
        delegate?.didChangeSearchText(searchText: removeWhiteSpacesText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else {
            return
        }
        delegate?.didSearch(searchText: searchText)
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if !text.isEmpty {
            delegate?.didBeginSearch()
        }
        return true
    }
}
