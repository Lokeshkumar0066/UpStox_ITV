//
//  CoinAPIResources.swift
//  UpStox_ITV
//
//  Created by Lokesh Agarwal on 13/11/24.
//

import Foundation

protocol DataAPIRepositoryProtocol {
    associatedtype ModelType
    func getCoinList(completion: @escaping ([ModelType]?, String?) -> Void)
}

struct CoinAPIResources: DataAPIRepositoryProtocol {
    
    // Instance of the HttpUtility to handle HTTP requests
    private let httpUtility: HttpUtility?
    typealias ModelType = CoinResponeModel
    
    init(httpUtility: HttpUtility) {
        self.httpUtility = httpUtility
    }

    // MARK: - Get Coin List
    // This method fetches a list of coins from the API
    func getCoinList(completion: @escaping ([CoinResponeModel]?, String?) -> Void) {
        if let requestUrl = URL(string: ApiEndpoints.coinList.urlString) {
            self.httpUtility?.getApiData(requestUrl: requestUrl, resultType: [CoinResponeModel].self) { (result, errorMessage) in
                if result == nil {
                    completion(nil, errorMessage)
                } else {
                    completion(result, errorMessage)
                }
            }
        } else {
            completion(nil, StringMessage.invalidURL.value)
        }
    }
    
}
