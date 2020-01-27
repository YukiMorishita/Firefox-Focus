//
//  TrackingProtectionFooterView.swift
//  Firefox Focus
//
//  Created by admin on 2020/01/19.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

protocol TrackingProtectionFooterViewDelegate: class {
    func didLearnMore()
}

class TrackingProtectionFooterView: UITableViewHeaderFooterView {
    
    weak var delegate: TrackingProtectionFooterViewDelegate?
    
    fileprivate let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        let attributedText = NSMutableAttributedString(string: "Choose whether Firefox Focus blocks ad, analytic, social, and other trackers.", attributes: [.foregroundColor: UIColor.lightGray])
        attributedText.append(NSAttributedString(string: " Learn more", attributes: [.foregroundColor: UIColor(named: "button")!]))
        
        label.attributedText = attributedText
        
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleLearnMore))
        addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleLearnMore() {
        delegate?.didLearnMore()
    }
}

