//
//  CustomNavigationBar.swift
//  UpStox_ITV
//
//  Created by Lokesh Agarwal on 13/11/24.
//

import UIKit

class CustomNavigationBar: UIView {
    
    private var titleLabel: UILabel!
    private var rightButtons: [UIButton] = []
    var rightButtonTapped: ((Int) -> Void)?
    var filterDot: UILabel!

    // Initializer to set up the custom navigation bar which accepeting multiple parameters.
    // - Parameters:
    // - frame: The frame for the navigation bar.
    // - title: An optional string for the title text.
    // - rightButtonImageName: An optional array of image names for the right-side buttons.
    // - backgroundColor: The background color of the navigation bar (defaults to blue).
    // - titleTextColor: The text color of the title (defaults to white).
    // - buttonCallback: An optional closure that will be called when any of the right buttons is tapped. It takes an integer index of the button tapped.
    
    init(frame: CGRect, title: String? = nil, rightButtonImageName: [String]? = nil, backgroundColor: UIColor = UIColor.blue, titleTextColor: UIColor = UIColor.white, buttonCallback: ((Int) -> Void)? = nil, buttonsShouldShow: Bool = true) {
        super.init(frame: frame)
        
        self.backgroundColor = backgroundColor
        self.rightButtonTapped = buttonCallback
        
        if let title = title {
            titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.textColor = titleTextColor
            titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
            titleLabel.numberOfLines = 1
            titleLabel.lineBreakMode = .byTruncatingTail
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            addSubview(titleLabel)
            
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
                titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            ])
        }
        
        if let rightButtonTitles = rightButtonImageName {
            for (index, title) in rightButtonTitles.enumerated() {
                let button = UIButton(type: .system)
                button.setImage(UIImage(systemName: title), for: .normal)
                button.tintColor = titleTextColor
                button.translatesAutoresizingMaskIntoConstraints = false
                button.isHidden = buttonsShouldShow
                addSubview(button)
                rightButtons.append(button)
                
                if index == 0 {
                    button.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15).isActive = true
                } else {
                    button.rightAnchor.constraint(equalTo: rightButtons[index - 1].leftAnchor, constant: -15).isActive = true
                }
                button.widthAnchor.constraint(equalToConstant: 25).isActive = true
                button.heightAnchor.constraint(equalToConstant: 25).isActive = true
                button.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
                button.tag = index
                button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
                
                // Set up the filter dot for the second button if needed
                if index == 1 {
                    self.filterDot = UILabel()
                    self.filterDot.backgroundColor = .white
                    self.filterDot.layer.cornerRadius = 2
                    self.filterDot.clipsToBounds = true
                    self.filterDot.translatesAutoresizingMaskIntoConstraints = false
                    addSubview(self.filterDot)
                    self.filterDot.isHidden = true
                    
                    NSLayoutConstraint.activate([
                        self.filterDot.widthAnchor.constraint(equalToConstant: 4),
                        self.filterDot.heightAnchor.constraint(equalToConstant: 4),
                        self.filterDot.topAnchor.constraint(equalTo: button.topAnchor, constant: -5),
                        self.filterDot.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -5)
                    ])
                }
            }
        }
        
        if let title = title, !title.isEmpty {
            if let firstButtonLeading = rightButtons.last?.leadingAnchor {
                NSLayoutConstraint.activate([
                    titleLabel.trailingAnchor.constraint(equalTo: firstButtonLeading, constant: -20)
                ])
            }
        }
    }
    
    func setRightButtonsVisibility(shouldShow: Bool) {
        for button in rightButtons {
            button.isHidden = shouldShow
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Action method triggered when the buttons are tapped by passing tag value
    @objc private func buttonTapped(_ sender: UIButton) {
        rightButtonTapped?(sender.tag)
    }
    
    
}
