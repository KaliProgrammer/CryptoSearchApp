//
//  CoinService.swift
//  CryptoApp
//
//  Created by MacBook Air on 26.04.2023.
//

import Foundation

enum CoinServiceError: Error {
case serverError(CoinError)
case unknown(String = "An unknown error occured.")
case decodingError(String = "Error parsing server response.")
}


class CoinService {
    
    static func fetchCoins(with endpoint: Endpoint,
                           completion: @escaping (Result<[Coin], CoinServiceError>) -> Void) {
        
        guard let request = endpoint.request else { return }
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.unknown(error.localizedDescription)))
                return
            }
            
            if let response = response as? HTTPURLResponse,
               response.statusCode != 200 {
                do {
                    let coinError = try JSONDecoder().decode(CoinError.self, from: data ?? Data())
                    completion(.failure(.serverError(coinError)))
                } catch let error {
                    completion(.failure(.unknown()))
                    print(error.localizedDescription)
                }
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let coinData = try decoder.decode(CoinArray.self, from: data)
                    completion(.success(coinData.data))
                } catch let error {
                    completion(.failure(.decodingError()))
                    print(error.localizedDescription)
                }
            } else {
                completion(.failure(.unknown()))
            }
        }
        .resume()
    }
    
}

