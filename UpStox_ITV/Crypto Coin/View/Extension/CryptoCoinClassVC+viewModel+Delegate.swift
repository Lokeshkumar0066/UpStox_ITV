//
//  CryptoCoinClassVC+viewModel+Delegate.swift
//  UpStox_ITV
//
//  Created by Lokesh Agarwal on 14/11/24.
//

import Foundation

extension CryptoCoinClassVC: CoinViewModelDelegate {
    func didReceiveResponse() {
        DispatchQueue.main.async {
            self.reloadTableView()
            self.view.activityStopAnimating()
            self.updateSearchAndFilterButtonsVisibility()
        }
    }
}
