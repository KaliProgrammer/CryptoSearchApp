//
//  HomeControllerViewModel.swift
//  CryptoApp
//
//  Created by MacBook Air on 26.04.2023.
//

import Foundation
import UIKit

class HomeControllerViewModel {
    
    var onCoinsUpdated: (() -> Void)?
    var onErrorMessage: ((CoinServiceError) -> Void)?
    
    private(set) var allCoins: [Coin] = [] {
        didSet {
            self.onCoinsUpdated?()
        }
    }
    
    private(set) var filteredCoins: [Coin] = []
    
    init() {
        self.fetchCoins()
    }

    
    public func fetchCoins() {
        let endPoint = Endpoint.fetchCoins()
        
        CoinService.fetchCoins(with: endPoint) { [weak self] result in
            switch result {
            case .success(let coins):
                self?.allCoins = coins
                print("DEBUG PRINT:", "\(coins.count) coins fetched.")
                
            case .failure(let error):
                self?.onErrorMessage?(error)
            }
        }
    }
}

// MARK: - Search

extension HomeControllerViewModel {
    public func inSearchMode(_ searchController: UISearchController) -> Bool {
        let isActive = searchController.isActive
        let searchText = searchController.searchBar.text ?? ""
        
        return isActive && !searchText.isEmpty
    }
    
    public func updateSearchController(searchBarText: String?) {
        self.filteredCoins = allCoins
        
        if let searchText = searchBarText?.lowercased() {
            guard !searchText.isEmpty else {
                self.onCoinsUpdated?()
                return
            }
            self.filteredCoins = self.filteredCoins.filter({$0.name.lowercased().contains(searchText)})
        }
        self.onCoinsUpdated?()
    }
}
