//
//  ApiEndPoints.swift
//  UpStox_ITV
//
//  Created by Lokesh Agarwal on 13/11/24.
//

import Foundation

enum ApiEndpoints {
    case coinList
    
    var urlString: String {
        switch self {
        case .coinList:
            return "https://37656be98b8f42ae8348e4da3ee3193f.api.mockbin.io/"
        }
    }
}
