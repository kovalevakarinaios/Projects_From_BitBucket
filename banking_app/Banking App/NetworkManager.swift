//
//  NetworkManager.swift
//  Banking App
//
//  Created by Karina Kovaleva on 12.05.23.
//

import Foundation

class NetworkManager {

    func getNews(completion: @escaping (Result<[News], Error>) -> ()) {
        guard let urlNews = URL(string: "https://belarusbank.by/api/news_info?lang=ru") else { print("Error: cannot create URL"); return }
        let urlNewsRequest = URLRequest(url: urlNews)
        let task = URLSession.shared.dataTask(with: urlNewsRequest) { data, _, error in
            if let data = data {
                do {
                    let result = try JSONDecoder().decode([News].self, from: data)
                    completion(.success(result))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    func getCardExchangeRates(completion: @escaping (Result<[CardExchangeRate], Error>) -> ()) {
        guard let urlNews = URL(string: "https://belarusbank.by/api/kurs_cards") else { print("Error: cannot create URL"); return }
        let urlNewsRequest = URLRequest(url: urlNews)
        let task = URLSession.shared.dataTask(with: urlNewsRequest) { data, _, error in
            if let data = data {
                do {
                    let result = try JSONDecoder().decode([CardExchangeRate].self, from: data)
                    completion(.success(result))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}
