//
//  FoodsViewController.swift
//  KAJU
//
//  Created by Duhan Boblanlı on 14.02.2023.
//

import UIKit


class FoodsViewController: UIViewController{
    
    @IBOutlet weak var SearchBar: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var refreshButton: UIButton!
    
    var foods: [Deneme] = [
        Deneme(foodName: "Muz", foodCallorie: "50kcal", foodQuantity: "30g"),
        Deneme(foodName: "Muz", foodCallorie: "50kcal", foodQuantity: "30g"),
        Deneme(foodName: "Muz", foodCallorie: "50kcal", foodQuantity: "30g")
    
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        SearchBar.delegate = self
        SearchBar.layer.cornerRadius = SearchBar.frame.size.height / 5
    }
    
    
    
    
} // end of FoodsViewController

//MARK: - UITableViewDelegate
extension FoodsViewController: UITableViewDelegate {
    //  Seçilen cellin indexini verir
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}

//MARK: - UITableViewDataSource
extension FoodsViewController: UITableViewDataSource {
    
    // Tablo görünümde kaç hücre ya da kaç satır istiyoruz burda belirtilir
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    // Belirlenen tablo cell indexinde gönderilen celli döndürür
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath)
        //cell.textLabel?.text = foods[indexPath.row].foodName
        return cell
    }
    
    
}

//MARK: - UITextFieldDelegate
extension FoodsViewController: UITextFieldDelegate {
    
    // Search buttona bastığında klavye kapatır
    @IBAction func searchBtn(_ sender: Any) {
        SearchBar.endEditing(true)
        //this is line of code helps to relode tableview --> eklenecek
    }
    
    // Klavyeden returne bastığında klavye kapatır
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        SearchBar.endEditing(true)
        return true
    }
    
    // Klavye kapandıysa yazıyı temizler
    // Yerine placeholder koyar
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if textField.text != "" {
            return true
        }else{
            textField.placeholder = "Type Something..."
            return false
        }
    }
    
    // Karakter arası boşlukları düzeltir
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let Item = SearchBar.text?.trimmingCharacters(in: .whitespaces) {
            let newText = Item.replacingOccurrences(of: " ", with: "")
            // written this to remove spaces between
        }
        
        SearchBar.text = ""
    }
}

 
    



    
    
    
    
    
   
    



    

