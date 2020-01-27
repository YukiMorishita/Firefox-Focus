//
//  AboutHeaderView.swift
//  Firefox Focus
//
//  Created by admin on 2020/01/19.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

protocol AboutHeaderViewDelegate: class {
    func didLearnMore()
}

class AboutHeaderView: UITableViewHeaderFooterView {
    
    weak var delegate: AboutHeaderViewDelegate?
    
    fileprivate let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Firefox Focus"
        label.textColor = UIColor(named: "onBackground")
        label.textAlignment = .center
        label.font = UIFont(name: "PTSans-NarrowBold", size: 36)
        label.numberOfLines = 1
        return label
    }()
    
    fileprivate let versionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "1.0.0"
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 1
        return label
    }()
    
    fileprivate let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "onBackground")
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        let topText = "Firefox Focus puts you in control.\n\n"
        let midText = """
        Use it as a private browser:
            • Search and browser right in the app
            • Block trackers (or update settings to
               allow trackers)
            • Erase to delete cookies as well as search
               and browsing history
        
        Use it as a Safari extension:
            • Block trackers fir improved privacy
            • Block Web fonts to reduce page size
           allow trackers)
        \n
        """
        let bottomText = "Firefox Focus is produced by Mozilla. Our mission is to foster a healthy, open Internet."
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.0
        
        let attributedText = NSMutableAttributedString(string: topText)
        attributedText.append(NSAttributedString(string: midText, attributes: [.paragraphStyle: paragraphStyle]))
        attributedText.append(NSAttributedString(string: bottomText))
        
        label.attributedText = attributedText
        
        return label
    }()
    
    lazy var learnMoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Learn more", for: .normal)
        button.setTitleColor(UIColor(named: "button"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleLearnMore), for: .touchUpInside)
        return button
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor(named: "background1")
        contentView.clipsToBounds = true
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(versionLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(learnMoreButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 50),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            versionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            versionLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            versionLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: versionLabel.bottomAnchor, constant: 20),
            descriptionLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 60),
            descriptionLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -60)
        ])
        
        NSLayoutConstraint.activate([
            learnMoreButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            learnMoreButton.leftAnchor.constraint(equalTo: descriptionLabel.leftAnchor),
            learnMoreButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -50),
            learnMoreButton.heightAnchor.constraint(equalToConstant: 14)
        ])
    }
    
    // MARK: - UIButton Handling
    
    @objc func handleLearnMore() {
        delegate?.didLearnMore()
    }
}

