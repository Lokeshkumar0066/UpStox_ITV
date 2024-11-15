//
//  CoinResponeModel.swift
//  UpStox_ITV
//
//  Created by Lokesh Agarwal on 13/11/24.
//

import Foundation
import UIKit

class CoinResponeModel: Codable {

    let name, symbol: String?
    let isNew, isActive: Bool
    let type: String?
    var imageName: String? // Custom property: The name of the image to display.
    var bgColor: UIColor = .clear // Custom property: The background color for the image, useful when the image has transparency.
    var isTagShown = false // Custom property: A flag indicating whether the "NEW" tag should be shown on top of the image.

    enum CodingKeys: String, CodingKey {
        case name, symbol
        case isNew = "is_new"
        case isActive = "is_active"
        case type
    }
    
    init(name: String?, symbol: String?, isNew: Bool, isActive: Bool, type: String?, imageName: String? = nil, bgColor: UIColor = .clear, isTagShown: Bool = false) {
        self.name = name
        self.symbol = symbol
        self.isNew = isNew
        self.isActive = isActive
        self.type = type
        self.imageName = imageName
        self.bgColor = bgColor
        self.isTagShown = isTagShown
    }
}
