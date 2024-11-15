//
//  Extension+UIView.swift
//  UpStox_ITV
//
//  Created by Lokesh Agarwal on 14/11/24.
//

import UIKit

extension UIView {
    
    // Method to apply default styling to the view, such as border color, width, and corner radius
    // Parameters:
    // - borderColor: The color of the border (default is light gray)
    // - borderWidth: The width of the border (default is 1)
    // - cornerRadius: The corner radius of the view (default is 14)
    func applyDefaultStyle(borderColor: UIColor = .black, borderWidth: CGFloat = 1, cornerRadius: CGFloat = 14) {
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
        layer.cornerRadius = cornerRadius
    }
}
