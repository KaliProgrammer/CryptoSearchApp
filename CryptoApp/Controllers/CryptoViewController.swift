//
//  CryptoViewController.swift
//  CryptoApp
//
//  Created by MacBook Air on 21.04.2023.
//

import UIKit
import SnapKit

class CryptoViewController: UIViewController {
    
    // MARK: - Variables
    let viewModel: ViewCryptoControllerViewModel
    
    // MARK: - UI Components
    private let scrollView: UIScrollView = {
       let scrollView = UIScrollView()
        return scrollView
    }()
    
    private let contentView: UIView = {
       let view = UIView()
        return view
    }()
    
    private let coinlogo: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(systemName: "qusetionmark")
        iv.tintColor = .label
        return iv
    }()
    
    private let rankLabel: UILabel = {
       let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.text = "Error"
        return label
    }()
    
    private let priceLabel: UILabel = {
       let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.text = "Error"
        return label
    }()
    
    private let marketCapLabel: UILabel = {
       let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.text = "Error"
        return label
    }()
    
    private let maxSupplyLabel: UILabel = {
       let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 500
        return label
    }()
    
    private lazy var vStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [rankLabel, priceLabel, marketCapLabel, maxSupplyLabel])
        stack.axis = .vertical
        stack.spacing = 12
        stack.distribution = .fill
        stack.alignment = .center
        
        return stack
    }()
    
    
    // MARK: - LifeCycle
    
    init(_ viewModel: ViewCryptoControllerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
        self.view.backgroundColor = .systemBackground
        self.navigationItem.title = self.viewModel.coin.name
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: nil, action: nil)
        
        self.rankLabel.text = self.viewModel.rankLabel
        self.priceLabel.text = self.viewModel.priceLabel
        self.marketCapLabel.text = self.viewModel.marketCapLabel
        self.maxSupplyLabel.text = self.viewModel.maxSupplyLabel
        
        self.coinlogo.sd_setImage(with: self.viewModel.coin.logoURL)
    }
    
    // MARK: - UI Setup
    
    func setupUI() {
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(contentView)
        self.contentView.addSubview(coinlogo)
        self.contentView.addSubview(vStack)
        
        let height = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        height.priority = UILayoutPriority(1)
        height.isActive = true
        

        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.snp.bottom)
            make.height.equalTo(view.snp.height)
            make.width.equalTo(view.snp.width)
        }
        
        contentView.snp.makeConstraints { make in
            make.leading.equalTo(scrollView.snp.leading)
            make.top.equalTo(scrollView.snp.top)
            make.trailing.equalTo(scrollView.snp.trailing)
            make.bottom.equalTo(scrollView.snp.bottom)
            make.width.equalTo(scrollView.snp.width)
        }
        
        coinlogo.snp.makeConstraints { make in
            make.centerX.equalTo(self.contentView.snp.centerX)
            make.top.equalTo(self.contentView.snp.top).offset(20)
            make.leading.equalTo(self.contentView.snp.leading)
            make.trailing.equalTo(self.contentView.snp.trailing)
            make.height.equalTo(200)
        }
        
        vStack.snp.makeConstraints { make in
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(coinlogo.snp.bottom).offset(20)
            make.leading.equalTo(self.contentView.snp.leading)
            make.trailing.equalTo(self.contentView.snp.trailing)
            make.bottom.equalTo(self.contentView.snp.bottom)

        }
        
    
        
    }
    
    // MARK: - Selectors
   
}
