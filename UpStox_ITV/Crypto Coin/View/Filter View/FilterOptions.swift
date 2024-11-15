//
//  FilterOptions.swift
//  UpStox_ITV
//
//  Created by Lokesh Agarwal on 14/11/24.
//

import Foundation

class FilterOptions {
    var title: String
    var isSelected: Bool = false
    var mapIndex: Int
    
    init(title: String, isSelected: Bool = false, mapIndex: Int) {
        self.title = title
        self.isSelected = isSelected
        self.mapIndex = mapIndex
    }
}
