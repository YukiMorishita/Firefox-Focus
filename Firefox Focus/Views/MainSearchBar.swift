//
//  HomeSearchBar.swift
//  Firefox Focus
//
//  Created by admin on 2020/01/17.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

enum SearchMode {
    case normal
    case result
}

class MainSearchBar: UISearchBar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSearchBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.setPlaceholderTextColor(UIColor(white: 1.0, alpha: 0.5))
    }
    
    private func setupSearchBar() {
        // Set search bar background color
        self.backgroundColor = UIColor(white: 1.0, alpha: 0.1)
        self.backgroundImage = UIImage()
        
        // Set cursor color
        self.tintColor = .white
        
        self.placeholder = "Search or enter address"
        self.setTextColor(.white)
        self.keyboardType = .webSearch
        self.returnKeyType = .search
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        self.enablesReturnKeyAutomatically = true
        
        self.layer.cornerRadius = 4.0
        self.layer.masksToBounds = true
        
        // Customized text field
        self.textField?.backgroundColor = UIColor(white: 1.0, alpha: 0.2)
        self.textField?.font = UIFont.systemFont(ofSize: 16)
        self.textField?.borderStyle = .none
        self.textField?.translatesAutoresizingMaskIntoConstraints = false
        
        // Set constraints
        self.textField?.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        self.textField?.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        self.textField?.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        self.textField?.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5).isActive = true
        
        self.textField?.layer.cornerRadius = 4.0
        self.textField?.layer.masksToBounds = true
        
        // Customized lupe icon image view
        if let lupeImageView = self.textField?.leftView as? UIImageView {
            lupeImageView.translatesAutoresizingMaskIntoConstraints = false
            
            // Hide lupe image view
            lupeImageView.widthAnchor.constraint(equalToConstant: 0).isActive = true
            lupeImageView.heightAnchor.constraint(equalToConstant: 0).isActive = true
        }
    }
    
    func changeMode(_ mode: SearchMode) {
        switch mode {
        case .normal:   self.normalMode()
        case .result:   self.resultMode()
        }
    }
    
    private func normalMode() {
        self.backgroundColor = UIColor(white: 1.0, alpha: 0.1)
        self.textField?.clearButtonMode = .whileEditing
        self.textField?.layer.borderColor = UIColor.clear.cgColor
        self.textField?.layer.borderWidth = 0.0
    }
    
    private func resultMode() {
        self.backgroundColor = .clear
        self.textField?.clearButtonMode = .never
        self.textField?.layer.borderColor = UIColor.black.withAlphaComponent(0.3).cgColor
        self.textField?.layer.borderWidth = 1.0
    }
    
    func setLeftView(_ mode: SearchMode) {
        
    }
    
    func setRightView(_ mode: SearchMode) {
        
    }
    
    func clearTextField() {
        self.textField?.text = nil
    }
}
