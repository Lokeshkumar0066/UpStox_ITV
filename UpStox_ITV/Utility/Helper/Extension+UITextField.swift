//
//  Extension+UITextField.swift
//  UpStox_ITV
//
//  Created by Lokesh Agarwal on 14/11/24.
//

import UIKit

extension UITextField {
    func changePlaceholderColor(placeholderText: String, color: UIColor = .white, alpha: CGFloat = 0.5) {
        self.attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [NSAttributedString.Key.foregroundColor: color.withAlphaComponent(alpha)]
        )
    }
}
