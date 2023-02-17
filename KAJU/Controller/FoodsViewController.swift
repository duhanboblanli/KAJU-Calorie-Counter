//
//  FoodsViewController.swift
//  KAJU
//
//  Created by Duhan Boblanlı on 14.02.2023.
//

import UIKit


class FoodsViewController: UIViewController, UISearchBarDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var foodViewModel = FoodViewModel()
    private var images: [UIImage]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        searchBar.searchTextField.leftView?.tintColor = UIColor( red: 170/255, green: 170/255, blue: 170/255, alpha: 1)
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search Foods", attributes: [NSAttributedString.Key.foregroundColor: UIColor( red: 170/255, green: 170/255, blue: 170/255, alpha: 1)])
        LoadFoodsData()
    }
    private func LoadFoodsData() { // Called at the beginning to do an API call and fill targetGames
        foodViewModel.fetchFoodData(pagination: false){ [weak self] in
            self?.tableView.dataSource = self
            self?.tableView.reloadData()
            print("hmm", self!.foodViewModel.getCount())
        }
    }

} // end of FoodsViewController

extension FoodsViewController: UIScrollViewDelegate{
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size
            .width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        spinner.color = UIColor( red: 170/255, green: 170/255, blue: 170/255, alpha: 1)
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (tableView.contentSize.height-100-scrollView.frame.size.height){
            
            guard !foodViewModel.apiService.isPaginating else {
                // we are already fetching more data
                return
            }
            self.tableView.tableFooterView = createSpinnerFooter()
            foodViewModel.fetchFoodData(pagination: true){ [weak self] in
                print("load more")
                self?.tableView.tableFooterView = nil
                self?.tableView.dataSource = self
                self?.tableView.reloadData()
            }
        }
    }
}

//MARK: - UITableViewDataSource
extension FoodsViewController: UITableViewDataSource, UITableViewDelegate {
    
    // Tablo görünümde kaç hücre ya da kaç satır istiyoruz burda belirtilir
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodViewModel.numberOfRowsInSection(section: section)
    }
    
    /*  Seçilen cellin indexini verir
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }*/
    
    // Belirlenen tablo cell indexinde gönderilen celli döndürür
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : FoodTableViewCell // Declare the cell
        cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FoodTableViewCell // Initialize cell
        let food = foodViewModel.cellForRowAt(indexPath: indexPath)
        cell.setCellWithValuesOf(food)
        return cell
    }
    
    
}

//MARK: - UITextFieldDelegate
extension FoodsViewController: UITextFieldDelegate {
    // Search buttona bastığında klavye kapatır
    @IBAction func searchBtn(_ sender: Any) {
        print("heyyyy")
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

 
    



    
    
    
    
    
   
    



    

