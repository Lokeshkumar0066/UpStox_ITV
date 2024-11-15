//
//  ActivityIndicatorManager.swift
//  UpStox_ITV
//
//  Created by Lokesh Agarwal on 14/11/24.
//

import UIKit

extension UIView {
    
    // Start animating an activity indicator on the view
    // - Parameters:
    // - activityColor: The color of the activity indicator (defaults to blue).
    // - backgroundColor: The background color of the view behind the activity indicator (defaults to clear).
    func activityStartAnimating(activityColor: UIColor = .blue, backgroundColor: UIColor = .clear) {
        let loaderView = UIView()
        loaderView.frame = CGRect.init(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        loaderView.backgroundColor = backgroundColor
        loaderView.tag = 475647
        
        var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicator = UIActivityIndicatorView(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.tintColor = .blue
        activityIndicator.color = activityColor
        activityIndicator.startAnimating()
        loaderView.addSubview(activityIndicator)
        self.addSubview(loaderView)
    }
    
    // Stop animating the activity indicator and remove the Loader View
    func activityStopAnimating() {
        DispatchQueue.main.async {
            if let background = self.viewWithTag(475647){
                background.removeFromSuperview()
            }
        }
    }
}
