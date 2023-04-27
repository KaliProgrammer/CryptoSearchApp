//
//  CoinCell.swift
//  CryptoApp
//
//  Created by MacBook Air on 10.04.2023.
//

import Foundation
import UIKit
import SnapKit
import SDWebImage

class CoinCell: UITableViewCell {
    
    //MARK: - Variables
    
    private(set) var coin: Coin!
    
    //MARK: - UI Components
    
    private let coinLogo: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(systemName: "questionmark")
        iv.tintColor = .black
        return iv
    }()
    
    private let coinName: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.text = "Error"
        return label
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with coin: Coin) {
        self.coin = coin
        self.coinName.text = coin.name

        self.coinLogo.sd_setImage(with: coin.logoURL)
    }
    // TODO: - PrepareForReuse
    override func prepareForReuse() {
        super.prepareForReuse()
        self.coinName.text = nil
        self.coinLogo.image = nil
    }
    
    // MARK: - UI Setup

    private func setupUI() {
        self.addSubview(coinLogo)
        self.addSubview(coinName)
        
        coinLogo.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY)
            make.leading.equalTo(self.snp.leading)
            make.width.equalTo(self.snp.height).multipliedBy(0.75)
            make.height.equalTo(self.snp.height).multipliedBy(0.75)
        }
        
        coinName.snp.makeConstraints { make in
            make.leading.equalTo(coinLogo.snp.trailing).offset(16)
            make.centerY.equalTo(self.snp.centerY)
        }
    }
}
