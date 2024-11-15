//
//  CryptoCoinClassVC+TableView+Delegate.swift
//  UpStox_ITV
//
//  Created by Lokesh Agarwal on 13/11/24.
//

import Foundation
import UIKit

extension CryptoCoinClassVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.coinViewModel?.numberOfRowsInSection() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as? CustomTableViewCell else { return UITableViewCell() }
        
        guard let item = self.coinViewModel?.cellForRowAt(indexPath: indexPath) else { return UITableViewCell() }
        cell.loadCell(item: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
