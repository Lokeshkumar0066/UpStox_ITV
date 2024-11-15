//
//  ErrorView.swift
//  UpStox_ITV
//
//  Created by Lokesh Agarwal on 15/11/24.
//

import UIKit

class ErrorView: UIView {
    
    private var titleLabel: UILabel!
    init(frame: CGRect, title: String? = nil, titleTextColor: UIColor = UIColor.white) {
        super.init(frame: frame)
        
        self.backgroundColor = backgroundColor
        
        if let title = title {
            titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.textColor = titleTextColor
            titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
            titleLabel.numberOfLines = 0
            titleLabel.lineBreakMode = .byWordWrapping
            titleLabel.textAlignment = .center
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            addSubview(titleLabel)
            
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
                titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
                titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            ])
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
