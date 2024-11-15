//
//  CoinViewModel.swift
//  UpStox_ITV
//
//  Created by Lokesh Agarwal on 13/11/24.
//

import Foundation
import UIKit

// didReceiveResponse(): This method is called to notify the view that the data is ready to be displayed.
protocol CoinViewModelDelegate {
    func didReceiveResponse()
}

class CoinViewModel {
    
    // Injected dependencies
    private let objDataManager: CDCrptoDataManager?
    private let coinAPIResources: CoinAPIResources?

    var coinList: [CoinResponeModel] = []
    private var tempCoinList: [CoinResponeModel] = []
    var delegate : CoinViewModelDelegate?
    
    // Dependency Injection via the initializer
    init(delegate: CoinViewModelDelegate?,
         dataManager: CDCrptoDataManager,
         apiManager: CoinAPIResources) {
        self.delegate = delegate
        self.objDataManager = dataManager
        self.coinAPIResources = apiManager
    }
    
    
    let operationQueue = OperationQueue()
    // Fetches the coin list from the API and updates local data based on the result
    func getCoinList(isPullToRefreshTriggered: Bool = false) {
        if !isPullToRefreshTriggered {
            self.fetchDataFromCDToDisplay()
        }
        self.operationQueue.cancelAllOperations()
        self.coinAPIResources?.getCoinList { [weak self] result, errorMessage in
            guard let self = self else {return}
            if result != nil {
                self.handleAPIResponse(result: result)
            } else {
                self.delegate?.didReceiveResponse()
            }
        }
    }
    
    // Handles the result from the API response
    private func handleAPIResponse(result: [CoinResponeModel]?) {
        if let result = result, result.count > 0 {
            self.mapResult(result: result)
            self.performOperationsWithDependencies()
        } else {
            self.delegate?.didReceiveResponse()
        }
    }
    
    private func performOperationsWithDependencies() {
       
        let deleteOperation = BlockOperation {
            if self.fetchRecordsFromCD()?.count ?? 0 != 0 {
                self.deleteCompleteDataFromCD()
            }
        }
        
        let saveOperation = BlockOperation {
            self.saveItemToCD()
        }
        
        // Set saveOperation to depend on deleteOperation
        saveOperation.addDependency(deleteOperation)
        operationQueue.addOperation(deleteOperation)
        operationQueue.addOperation(saveOperation)
    }
    
    // Returns the number of rows in the table
    func numberOfRowsInSection() -> Int {
        return self.coinList.count
    }
    
    // Returns the coin object for a given index path
    func cellForRowAt(indexPath: IndexPath) -> CoinResponeModel? {
        return self.coinList[safe: indexPath.row]
    }
    
    // Maps the API result to the coin list array and updates the UI via delegate
    private func mapResult(result: [CoinResponeModel]?) {
        self.coinList.removeAll()
        self.tempCoinList.removeAll()
        self.coinList = result ?? []
        self.tempCoinList = result ?? []
        self.mapCoinImages()
        self.delegate?.didReceiveResponse()
    }
    
    // Maps the image and other properties based on the type and status of each coin
    private func mapCoinImages() {
        for item in self.coinList {
            if item.type?.lowercased() == "coin" && item.isActive == true {
                item.imageName = "coin_Active"
                item.bgColor = .clear
                item.isTagShown = false
            } else if item.type?.lowercased() == "token" && item.isActive == true {
                item.imageName = "token_active"
                item.bgColor = .clear
                item.isTagShown = false
            } else if item.isActive == false {
                item.imageName = "inactive"
                item.bgColor = .gray
                item.isTagShown = true
            } else if item.isNew == true {
                item.imageName = "token_active"
                item.bgColor = .clear
                item.isTagShown = true
            }
        }
    }
    
    // Saves the current list of coins to Core Data
    private func saveItemToCD() {
        self.objDataManager?.saveRecord(item: self.coinList)
    }
    
    // Fetching records from Core Data
    private func fetchRecordsFromCD() -> [CoinResponeModel]? {
        return self.objDataManager?.fetchAll()
    }
    
    // Post fetching the records from core data and send the data to display
    private func fetchDataFromCDToDisplay() {
        let result = self.fetchRecordsFromCD()
        if result?.count ?? 0 != 0 {
            self.mapResult(result: result)
        }
    }
    
    // Deletes all coin data from Core Data
    private func deleteCompleteDataFromCD() {
        self.objDataManager?.deleteCompleteData()
    }
    
    // Filters the coin list based on the search text
    func filterDataBasedOnSearch(searchText: String?) {
        if let searchText = searchText, !searchText.isEmpty {
            let filterData = self.tempCoinList.filter { coin in
                let lowercasedSearchText = searchText.lowercased()
                return (coin.symbol?.lowercased().contains(lowercasedSearchText) ?? false) ||
                (coin.name?.lowercased().contains(lowercasedSearchText) ?? false)
            }
            self.coinList = filterData
        } else {
            self.coinList = self.tempCoinList
        }
        self.delegate?.didReceiveResponse()
    }
    
    // Apply filters to the coin list based on selected filter options
    func applyFilter(selectedFilterOptions: [FilterOptions]) {
        self.coinList = []
        if selectedFilterOptions.isEmpty {
            self.coinList = self.tempCoinList
        } else {
            let filteredValue = self.tempCoinList
            selectedFilterOptions.forEach { filter in
                var output: [CoinResponeModel] = []
                switch filter.title {
                case StringMessage.activeCoins.value:
                    output = filteredValue.filter { $0.isActive }
                    
                case StringMessage.inactiveCoins.value:
                    output = filteredValue.filter { !$0.isActive }
                    
                case StringMessage.onlyTokens.value:
                    output = filteredValue.filter { $0.type?.lowercased() ?? "" == "token" }
                    
                case StringMessage.onlyCoins.value:
                    output = filteredValue.filter { $0.type?.lowercased() ?? "" == "coin" }
                    
                case StringMessage.newCoins.value:
                    output = filteredValue.filter { $0.isNew }
                    
                default:
                    break
                }
                self.coinList.append(contentsOf: output)
            }
            self.coinList = self.coinList.removeDuplicateElements()
        }
        self.delegate?.didReceiveResponse()
    }
}
