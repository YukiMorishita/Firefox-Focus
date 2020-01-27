//
//  SettingCell.swift
//  Firefox Focus
//
//  Created by admin on 2020/01/18.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

protocol SettingCellDelegate: class {
    func didLearnMore(cell: SettingCell)
}

class SettingCell: UITableViewCell {
    
    weak var delegate: SettingCellDelegate?
    
    var setting: Setting? {
        didSet {
            guard let setting = setting else { return }
            titleLabel.text = setting.title
            descriptionLabel.text = setting.description
        }
    }
    
    private var descriptionLabelBottomConstraint: NSLayoutConstraint!
    private var learnMoreButtonBottomConstraint: NSLayoutConstraint!
    
    fileprivate let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "onBackground")
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 1
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    fileprivate let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var learnMoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Learn more", for: .normal)
        button.setTitleColor(UIColor(named: "button"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.addTarget(self, action: #selector(handleLearnMore), for: .touchUpInside)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor(named: "background2")
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(learnMoreButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20)
        ])
        
        descriptionLabelBottomConstraint = descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            descriptionLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20)
        ])
        
        learnMoreButtonBottomConstraint = learnMoreButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        
        NSLayoutConstraint.activate([
            learnMoreButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 4),
            learnMoreButton.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            learnMoreButton.heightAnchor.constraint(equalToConstant: 12)
        ])
    }
    
    public func setLearnMoreButtonIsHidden(_ isHidden: Bool) {
        learnMoreButton.isHidden = isHidden
        
        // Update constraints
        descriptionLabelBottomConstraint.isActive = isHidden ? true : false
        learnMoreButtonBottomConstraint.isActive = isHidden ? false : true
    }
    
    // MARK: UIButton Handling
    
    @objc func handleLearnMore() {
        delegate?.didLearnMore(cell: self)
    }
}
