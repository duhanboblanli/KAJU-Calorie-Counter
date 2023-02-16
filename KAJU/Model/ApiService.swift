//
//  ApiService.swift
//  KAJU
//
//  Created by Umut Ulaş Demir on 14.02.2023.
//

import Foundation
import UIKit

class ApiService {
    
    private var dataTask: URLSessionDataTask?
    var isPaginating = false
    
    // Get the foods with an API call and return it as a decoded object (See 'Model.FoodsData')
    func getFoodsData(pagination: Bool, foodsUrl: String,completion: @escaping (Result<FoodsData, Error>) -> Void) {
        
        if pagination{
            isPaginating = true
        }
        
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
                
                let jsonData = try decoder.decode(FoodsData.self, from: data)
                
                // Back to the main thread
                DispatchQueue.main.async {
                    completion(.success(jsonData))
                    if pagination{
                        self.isPaginating = false
                    }
                }
            } catch let error {
                completion(.failure(error))
            }
            
        }
        dataTask?.resume()
    }
    func getImageDataFrom(url: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        print("Fetching image11111111.. ", url)
        guard let url = URL(string: url) else {return}
        dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            print("Fetching image22222222.. ", url)
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
                guard let image = UIImage(data: data) else {return}
                // Back to the main thread
                DispatchQueue.main.async {
                    completion(.success(image))
                }
            } catch let error {
                completion(.failure(error))
            }
            
        }
        dataTask?.resume()
    }
}

