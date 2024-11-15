//
//  CDCrptoDataRepository.swift
//  UpStox_ITV
//
//  Created by Lokesh Agarwal on 14/11/24.
//

import Foundation
import CoreData

protocol CryptoRepositery {
    func saveRecord(coin: [CoinResponeModel])
    func fetchAll() -> [CoinResponeModel]?
    func deleteCompleteData()
}

class CDCrptoDataRepository: CryptoRepositery {
    
    // Saving the coin records using a background task to avoid blocking the main thread.
    func saveRecord(coin: [CoinResponeModel]) {
        PersistentStorage.shared.persistentContainer.performBackgroundTask { privateManageContext in
            // Perform the insertion of each coin record in the background context
            coin.enumerated().forEach { (index, item) in
                let cryCoin = CDCryptoCoin(context: privateManageContext)
                cryCoin.isActive = item.isActive
                cryCoin.isNew = item.isNew
                cryCoin.name = item.name
                cryCoin.symbol = item.symbol
                cryCoin.type = item.type
                cryCoin.id = UUID()
                cryCoin.sequenceId = Int16(index)
            }
            
            // Save the changes to the background context if there are any
            if privateManageContext.hasChanges {
                do {
                    try privateManageContext.save() // Attempt to save the data
                } catch {
                    // Handle error if the save fails
                    print("Error saving coin records: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func fetchAll() -> [CoinResponeModel]? {
        var data: [CoinResponeModel] = []
        do {
            let fetchRequest = CDCryptoCoin.fetchRequest()
            // Create sort descriptor(s)
            let sortDescriptor = NSSortDescriptor(key: "sequenceId", ascending: true) // Example: sort by 'sequenceId' in ascending order
            
            fetchRequest.sortDescriptors = [sortDescriptor]
            
            // Setting `returnsObjectsAsFaults` to false to avoid faulting when accessing objects
            fetchRequest.returnsObjectsAsFaults = false
            
            // Perform the fetch request
            let results = try PersistentStorage.shared.context.fetch(fetchRequest)
            results.forEach({ record in
                data.append(record.convertToCoinResponseModel())
            })
            return data
            
        } catch let error {
            debugPrint("fetchAll: \(error.localizedDescription)")
            return nil
        }
    }
    
    // Deleting all records from the CDCryptoCoin entity.
    func deleteCompleteData() {
        PersistentStorage.shared.persistentContainer.performBackgroundTask { privateManagedContext in
            let fetchRequest: NSFetchRequest = CDCryptoCoin.fetchRequest()
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let results = try privateManagedContext.fetch(fetchRequest)
                results.forEach { coin in
                    privateManagedContext.delete(coin)
                }
                if privateManagedContext.hasChanges {
                    do {
                        try privateManagedContext.save()
                    } catch {
                        debugPrint("Error saving after deletion: \(error.localizedDescription)")
                    }
                }
            } catch {
                debugPrint("Error fetching data for deletion: \(error.localizedDescription)")
            }
        }
    }


}
