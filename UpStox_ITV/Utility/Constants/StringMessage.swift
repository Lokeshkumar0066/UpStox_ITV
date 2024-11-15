//
//  StringMessage.swift
//  UpStox_ITV
//
//  Created by Lokesh Agarwal on 14/11/24.
//

import Foundation

enum StringMessage {
    case noInternet
    case parseIssue
    case fetchIssue
    case invalidURL
    case searchPlaceHolder
    case navigationBarTitle
    case activeCoins
    case inactiveCoins
    case onlyTokens
    case onlyCoins
    case newCoins
    case cancel
    case searchText
    case noData
    
    var value: String {
        switch self {
        case .noInternet:
            return "No internet connection."
        case .parseIssue:
            return "Failed to parse the data."
        case .fetchIssue:
            return "Failed to fetch data."
        case .invalidURL:
            return "Invalid URL."
        case .searchPlaceHolder:
            return "Search..."
        case .navigationBarTitle:
            return "COIN"
        case .activeCoins:
            return "Active Coins"
        case .inactiveCoins:
            return "Inactive Coins"
        case .onlyTokens:
            return "Only Tokens"
        case .onlyCoins:
            return "Only Coins"
        case .newCoins:
            return "New Coins"
        case .cancel:
            return "Cancel"
        case .searchText:
            return "Search"
        case .noData:
            return "No data found. Please pull to refresh or check your internet connection."
        }
    }
}

