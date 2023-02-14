//
//  ApiService.swift
//  KAJU
//
//  Created by Umut Ulaş Demir on 14.02.2023.
//

import Foundation

class ApiService {
    
    private var dataTask: URLSessionDataTask?
    
    // Get the foods with an API call and return it as a decoded object (See 'Model.FoodsData')
    func getFoodsData(foodsUrl: String,completion: @escaping (Result<FoodData, Error>) -> Void) {
        
        //foodsUrl = "https://api.rawg.io/api/games?key=3be8af6ebf124ffe81d90f514e59856c"
        
        guard let url = URL(string: foodsUrl) else {return}
        
        // Create URL Session - work on the background
        dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            // Handle Error
            if let error = error {
                completion(.failure(error))
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                // Handle Empty Response
                print("Empty Response")
                return
            }
            print("Response status code: \(response.statusCode)")
            
            guard let data = data else {
                // Handle Empty Data
                print("Empty Data")
                return
            }
            
            do {
                // Parse the data
                let decoder = JSONDecoder()
                
                let jsonData = try decoder.decode(FoodData.self, from: data)
                
                // Back to the main thread
                DispatchQueue.main.async {
                    completion(.success(jsonData))
                }
            } catch let error {
                completion(.failure(error))
            }
            
        }
        dataTask?.resume()
    }
}

