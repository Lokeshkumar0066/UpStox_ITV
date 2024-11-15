//
//  HttpUtility.swift
//  UpStox_ITV
//
//  Created by Lokesh Agarwal on 13/11/24.
//

import Foundation

struct HttpUtility {   
    
    // This method performs a GET request to fetch data from an API and decodes the response into a specified model type (T) that is the Generic type
    func getApiData<T: Decodable>(requestUrl: URL, resultType: T.Type, completionHandler: @escaping (T?, String?) -> Void) {
        if !NetworkReachability.shared.isInternetAvailable() {
            completionHandler(nil, StringMessage.noInternet.value)
            return
        }
        URLSession.shared.dataTask(with: requestUrl) { (responseData, httpUrlResponse, error) in
            if error == nil, let responseData = responseData, responseData.count > 0 {
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(T.self, from: responseData)
                    completionHandler(result, nil)
                } catch {
                    completionHandler(nil, StringMessage.parseIssue.value)
                }
            } else {
                completionHandler(nil, StringMessage.fetchIssue.value)
            }
        }.resume()
    }
    
}
