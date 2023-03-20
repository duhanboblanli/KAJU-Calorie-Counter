//
//  FrequentFoods.swift
//  KAJU
//
//  Created by Umut Ulaş Demir on 20.03.2023.
//

import Foundation
import UIKit

class FrequentFoods{
    var breakfastList: [FoodStruct]?
    var lunchList: [FoodStruct]?
    var dinnerList: [FoodStruct]?
    var snacksList: [FoodStruct]?
    
    var breakfastImageList: [String]?
    var lunchImageList: [String]?
    var dinnerImageList: [String]?
    var snacksImageList: [String]?
    
    private var dataTask: URLSessionDataTask?
    
    func getImageDataFrom(url: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let url = URL(string: url) else {return}
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
