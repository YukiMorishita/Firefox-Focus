//
//  MainToolBar.swift
//  Firefox Focus
//
//  Created by admin on 2020/01/21.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

enum ToolBarMode {
    case normal
    case result
}

protocol MainToolBarDelegate: class {
    func didGoBack()
    func didGoForward()
    func didRefresh()
    func didSettings()
}

class MainToolBar: UIView {
    
    weak var delegate: MainToolBarDelegate?
    
    lazy var goBackButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "goBack"), for: .normal)
        button.alpha = 0.5
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleGoBack), for: .touchUpInside)
        return button
    }()
    
    lazy var goForwardButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "goForward"), for: .normal)
        button.alpha = 0.5
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleGoForward), for: .touchUpInside)
        return button
    }()
    
    lazy var refreshButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "refresh"), for: .normal)
        button.alpha = 0.5
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        return button
    }()
    
    lazy var settingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "settings"), for: .normal)
        button.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        return button
    }()
    
    init(mode: ToolBarMode) {
        super.init(frame: .zero)
        setupViews()
        switch mode {
        case .normal:   self.normalMode()
        case .result:   self.resultMode()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        let stackView = UIStackView(arrangedSubviews: [goBackButton, goForwardButton, refreshButton, settingsButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        
        self.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            stackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 48),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor),
            stackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -48)
        ])
    }
    
    private func normalMode() {
        self.backgroundColor = .clear
    }
    
    private func resultMode() {
        self.backgroundColor = UIColor(named: "gradient3")?.withAlphaComponent(0.9)
    }
    
    func setGoBackButtonIsEnable(_ isEnable: Bool, animated: Bool) {
        let duration = animated ? 0.3 : 0.0
        UIView.animate(withDuration: duration, animations: {
            self.goBackButton.alpha = isEnable ? 1.0 : 0.5
        }, completion: { completed in
            self.goBackButton.isEnabled = isEnable
        })
    }
    
    func setGoForwardIsEnabled(_ isEnable: Bool, animated: Bool) {
        let duration = animated ? 0.3 : 0.0
        UIView.animate(withDuration: duration, animations: {
            self.goForwardButton.alpha = isEnable ? 1.0 : 0.5
        }, completion: { completed in
            self.goForwardButton.isEnabled = isEnable
        })
    }
    
    // MARK: - UIButton Handling
    
    @objc func handleGoBack() {
        delegate?.didGoBack()
    }
    
    @objc func handleGoForward() {
        delegate?.didGoForward()
    }
    
    @objc func handleRefresh() {
        delegate?.didRefresh()
    }
    
    @objc func handleSettings() {
        delegate?.didSettings()
    }
}

