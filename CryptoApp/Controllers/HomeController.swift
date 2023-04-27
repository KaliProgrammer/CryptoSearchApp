//
//  ViewController.swift
//  CryptoApp
//
//  Created by MacBook Air on 10.04.2023.
//

import UIKit
import SnapKit

class HomeController: UIViewController{
    
    // MARK: - Variables
    
    private let viewModel: HomeControllerViewModel
    
    // MARK: - UI Components
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .systemBackground
        tv.register(CoinCell.self, forCellReuseIdentifier: CoinCell.reuseIdentifier)
        return tv
    }()
    
    
    
    // MARK: - UI Setup
    

    
    // MARK: - TableView Functions

    
    // MARK: - LifeCycle
    init(_ viewModel: HomeControllerViewModel = HomeControllerViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor  = .systemBackground
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.setupUI()
        self.setupSearchController()
        
        self.viewModel.onCoinsUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        
        self.viewModel.onErrorMessage = { [weak self] error in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                switch error {
                case .serverError(let serverError):
                    alert.title = "Server Error \(serverError.errorCode)"
                    alert.message = serverError.errorMessage
                case .unknown(let string):
                    alert.title = "Error Fetching Coins"
                    alert.message = string
                case .decodingError(let string):
                    alert.title = "Error Parsing Data"
                    alert.message = string
                }
                self?.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    func setupUI() {
        self.navigationItem.title = "Crypto"
        self.view.addSubview(tableView)
        
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.view.snp.top)
            make.bottom.equalTo(self.view.snp.bottom)
            make.leading.equalTo(self.view.snp.leading)
            make.trailing.equalTo(self.view.snp.trailing)
        }
    }
    
    private func setupSearchController() {
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.placeholder = "Search Cryptos"
        
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = false
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        self.searchController.searchBar.delegate = self
        
        self.searchController.searchBar.showsBookmarkButton = true
        
        self.searchController.searchBar.setImage(UIImage(systemName: "line.horizontal.3.decrease"), for: .bookmark, state: .normal)
    }
}


// MARK: - Search Controller Functions

extension HomeController: UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        self.viewModel.updateSearchController(searchBarText: searchController.searchBar.text)
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        print("Search bar button called!")
    }
}



extension HomeController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let inSearchMode = self.viewModel.inSearchMode(self.searchController)
        return inSearchMode ? self.viewModel.filteredCoins.count : self.viewModel.allCoins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CoinCell.reuseIdentifier, for: indexPath) as? CoinCell else {
            fatalError("Unable to dequeue CoinCell in HomeController")
        }
        
        
        let inSearchMode = self.viewModel.inSearchMode(self.searchController)
        let coin = inSearchMode ? self.viewModel.filteredCoins[indexPath.row] : self.viewModel.allCoins[indexPath.row]
        cell.configure(with: coin)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        88
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        
        let inSearchMode = self.viewModel.inSearchMode(self.searchController)
        let coin = inSearchMode ? self.viewModel.filteredCoins[indexPath.row] : self.viewModel.allCoins[indexPath.row]
        
        let viewModel = ViewCryptoControllerViewModel(coin)
        let vc = CryptoViewController(viewModel)
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

