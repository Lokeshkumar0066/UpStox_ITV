//
//  CDCryptoCoin+CoreDataProperties.swift
//  UpStox_ITV
//
//  Created by Lokesh Agarwal on 15/11/24.
//
//

import Foundation
import CoreData


extension CDCryptoCoin {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDCryptoCoin> {
        return NSFetchRequest<CDCryptoCoin>(entityName: "CDCryptoCoin")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var isActive: Bool
    @NSManaged public var isNew: Bool
    @NSManaged public var name: String?
    @NSManaged public var sequenceId: Int16
    @NSManaged public var symbol: String?
    @NSManaged public var type: String?

    func convertToCoinResponseModel() -> CoinResponeModel {
        return CoinResponeModel(name: self.name, symbol: self.symbol, isNew: self.isNew, isActive: self.isActive, type: self.type)
    }
}

extension CDCryptoCoin : Identifiable {

}
