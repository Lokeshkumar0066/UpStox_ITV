//
//  CryptoCoinClassVC+SearchBar+Delegate.swift
//  UpStox_ITV
//
//  Created by Lokesh Agarwal on 14/11/24.
//

import Foundation

extension CryptoCoinClassVC: CustomSearchBarDelegate {
    func textFieldDidChange(searchText: String?) {
        self.coinViewModel?.filterDataBasedOnSearch(searchText: searchText)
    }
}
