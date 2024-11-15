//
//  Extension+Array.swift
//  UpStox_ITV
//
//  Created by Lokesh Agarwal on 13/11/24.
//

import Foundation

extension Array {
    // Safe subscript to access array elements. Returns 'nil' if the index is out of bounds.
    subscript(safe index: Int) -> Element? {
        guard indices ~= index else {
            return nil
        }
        return self[index]
    }
}

// Function to remove duplicate elements from an array based on the 'symbol' property.
extension Array where Element: CoinResponeModel {
    func removeDuplicateElements() -> [Element] {
        var encounteredNames: [String] = []
        var result: [Element] = []

        for item in self {
            if let entityName = item.symbol?.lowercased(), !encounteredNames.contains(entityName) {
                encounteredNames.append(entityName)
                result.append(item)
            }
        }
        return result
    }
}
