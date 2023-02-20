//
//  RecipeApiService.swift
//  KAJU
//
//  Created by Duhan Boblanlı on 19.02.2023.
//
/*
import Foundation
import UIKit

class RecipeApiService {
    
    private var dataTask: URLSessionDataTask?
    var isPaginating = false
    
    // Get the recipe with an API call and return it as a decoded object (See 'RecipeApiModel')
    func getRecipesData(pagination: Bool, recipesUrl: String,completion: @escaping (Result<RecipesData, Error>) -> Void) {
        
        if pagination{
            isPaginating = true
        }
        
        //recipesUrl
        //https://api.edamam.com/api/recipes/v2?type=public&app_id=78a155af&app_key=4d8c707a337640bf241ab4076fc94de7&imageSize=LARGE
        guard let url = URL(string: recipesUrl) else {return}
        
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
                
                // data'dan gelen verileri RecipesData tipinde decode et
                let jsonData = try decoder.decode(RecipesData.self, from: data)
                
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


*/
