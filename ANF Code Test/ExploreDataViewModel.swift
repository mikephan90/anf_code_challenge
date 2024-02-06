//
//  ExploreDataViewModel.swift
//  ANF Code Test
//
//  Created by Mike Phan on 2/5/24.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
}

class ExploreDataViewModel {
    func fetchData(completion: @escaping (Result<[ExploreDataResponse], Error>) -> Void) {
        
        // ensure url is a valid endpoint
        guard let url = URL(string: "https://www.abercrombie.com/anf/nativeapp/qa/codetest/codeTest_exploreData.json") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        // create urlsession to call API for json data
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            // Decode the data using the ExploreDataResponse struct and return
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode([ExploreDataResponse].self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
