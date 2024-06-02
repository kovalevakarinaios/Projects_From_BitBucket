//
//  NetworkAPI.swift
//  ATMs
//
//  Created by Karina Kovaleva on 27.12.22.
//

import Foundation

final class NetworkAPI {
    func getATMsList(completion: @escaping ([ATM]) -> Void) {
        guard let url = URL(string: "https://belarusbank.by/api/atm") else { return }
        let urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest) { data, _, _ in
            let decoder = JSONDecoder()
            guard let data = data,
                  let response = try? decoder.decode([ATM].self, from: data) else { return }
            completion(response)
        }
        .resume()
    }
}
