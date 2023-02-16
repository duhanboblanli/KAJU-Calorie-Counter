//
//  RecipesViewController.swift
//  KAJU
//
//  Created by Duhan Boblanlı on 15.02.2023.
//

import UIKit

class RecipesViewController: UIViewController {
    
    
    let ColorHardDarkGreen = UIColor( red: 40/255, green: 71/255, blue: 92/255, alpha: 1)
    let ColorDarkGreen = UIColor( red: 47/255, green: 136/255, blue: 134/255, alpha: 1)
    let ColorLightGreen = UIColor( red: 132/255, green: 198/255, blue: 155/255, alpha: 1)
    
    @IBOutlet weak var firstButtonView: UIView!
    @IBOutlet weak var secondButtonView: UIView!
    @IBOutlet weak var firstBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var secondBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var discoverButton: UIButton!
    @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet weak var discoverLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    
    
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    
    var foods: [Deneme] = [
        Deneme(foodName: "Muz", foodCallorie: "50kcal", foodQuantity: "30g"),
        Deneme(foodName: "Muz", foodCallorie: "50kcal", foodQuantity: "30g"),
        Deneme(foodName: "Muz", foodCallorie: "50kcal", foodQuantity: "30g")
    
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstBottomConstraint.constant = 4.0
        secondBottomConstraint.constant = 3.0
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        searchBar.layer.cornerRadius = searchBar.frame.size.height / 5
        
        
        
        
    }
    
    @IBAction func firstTabPressed(_ sender: UIButton) {
        firstView.isHidden = false
        secondView.isHidden = true
        firstBottomConstraint.constant = 4.0
        secondBottomConstraint.constant = 3.0
        firstButtonView.backgroundColor = ColorDarkGreen
        secondButtonView.backgroundColor = ColorHardDarkGreen
        discoverLabel.textColor = ColorDarkGreen
        favoritesLabel.textColor = UIColor.lightGray
    }
    
    @IBAction func secondTabPressed(_ sender: UIButton) {
        firstView.isHidden = true
        secondView.isHidden = false
        firstBottomConstraint.constant = 3.0
        secondBottomConstraint.constant = 4.0
        firstButtonView.backgroundColor = ColorHardDarkGreen
        secondButtonView.backgroundColor = ColorDarkGreen
        discoverLabel.textColor = UIColor.lightGray
        favoritesLabel.textColor = ColorDarkGreen
    }
    
}// end of RecipesViewController

//MARK: - UITableViewDelegate
extension RecipesViewController: UITableViewDelegate {
    //  Seçilen cellin indexini verir
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}

//MARK: - UITableViewDataSource
extension RecipesViewController: UITableViewDataSource {
    
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
extension RecipesViewController: UITextFieldDelegate {
    
    // Search buttona bastığında klavye kapatır
    @IBAction func searchBtn(_ sender: Any) {
        searchBar.endEditing(true)
        //this is line of code helps to relode tableview --> eklenecek
    }
    
    // Klavyeden returne bastığında klavye kapatır
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchBar.endEditing(true)
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
        
        if let Item = searchBar.text?.trimmingCharacters(in: .whitespaces) {
            let newText = Item.replacingOccurrences(of: " ", with: "")
            // written this to remove spaces between
        }
        
        searchBar.text = ""
    }
}

    
