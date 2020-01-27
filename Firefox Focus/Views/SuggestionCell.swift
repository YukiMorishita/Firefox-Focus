//
//  SuggestionCell.swift
//  Firefox Focus
//
//  Created by admin on 2020/01/17.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class SuggestionCell: UITableViewCell {
    
    var suggestion: Suggestion? {
        didSet {
            guard let suggestion = suggestion else { return }
            suggestionLabel.text = suggestion.title
        }
    }
    
    fileprivate let lupeImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.tintColor = UIColor(named: "onBackground")
        iv.image = #imageLiteral(resourceName: "search").withRenderingMode(.alwaysTemplate)
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    fileprivate let suggestionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Search Suggestion"
        label.textColor = UIColor(named: "onBackground")
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        contentView.alpha = highlighted ? 0.5 : 1.0
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = .clear
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        contentView.backgroundColor = UIColor(named: "background1")
        contentView.clipsToBounds = true
        
        contentView.addSubview(lupeImageView)
        contentView.addSubview(suggestionLabel)
        
        NSLayoutConstraint.activate([
            lupeImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            lupeImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
            lupeImageView.widthAnchor.constraint(equalToConstant: 30),
            lupeImageView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            suggestionLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            suggestionLabel.leftAnchor.constraint(equalTo: lupeImageView.rightAnchor, constant: 8),
            suggestionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            suggestionLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8)
        ])
    }
}
