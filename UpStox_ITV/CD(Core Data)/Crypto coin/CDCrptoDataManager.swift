//
//  CDCrptoDataManager.swift
//  UpStox_ITV
//
//  Created by Lokesh Agarwal on 14/11/24.
//

import Foundation

// Protocol defining the responsibilities of a data repository to perform CURD operation function calls.
protocol DataRepositoryProtocol {
    associatedtype ItemType
    func saveRecord(item: [ItemType])
    func fetchAll() -> [ItemType]?
    func deleteCompleteData()
}

struct CDCrptoDataManager: DataRepositoryProtocol {
    typealias ItemType = CoinResponeModel
    
    private var objDataRepositery: CryptoRepositery?
        
    // Initializer to inject the data repository dependency. Allows for loose coupling and better testability.
    init(objDataRepositery: CryptoRepositery?) {
        self.objDataRepositery = objDataRepositery
    }

    func saveRecord(item: [CoinResponeModel]) {
        self.objDataRepositery?.saveRecord(coin: item)
    }
    
    func fetchAll() -> [CoinResponeModel]? {
        return self.objDataRepositery?.fetchAll()
    }
        
    func deleteCompleteData() {
        self.objDataRepositery?.deleteCompleteData()
    }    
}
