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
    
    private var foodViewModel = FoodManager()
    private var images: [UIImage]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        searchBar.searchTextField.leftView?.tintColor = UIColor( red: 170/255, green: 170/255, blue: 170/255, alpha: 1)
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search For A Food", attributes: [NSAttributedString.Key.foregroundColor: UIColor( red: 170/255, green: 170/255, blue: 170/255, alpha: 1)])
        LoadFoodsData()
    }
    private func LoadFoodsData() {
        // Called at the beginning to do an API call and fill targetFoods
        foodViewModel.fetchFoodData(pagination: false){ [weak self] in
            self?.tableView.dataSource = self
            self?.tableView.reloadData()
        }
    }

} // end of FoodsViewController

//MARK: - UIScrollViewDelegate
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
    
    // Belirlenen tablo cell indexinde gönderilen celli döndürür
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var foodCell : FoodTableViewCell // Declare the cell
        foodCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FoodTableViewCell // Initialize cell
        let food = foodViewModel.cellForRowAt(indexPath: indexPath)
        foodCell.setCellWithValuesOf(food)
        return foodCell
    }
}

//MARK: - UITextFieldDelegate
extension FoodsViewController: UITextFieldDelegate {
    
    // Klavyeden returne bastığında klavye kapatır
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        searchBar.endEditing(true)
        return true
    }
    
    // Klavye kapandıysa ve bir şey yazılmadıysa yerine placeholder koyar
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if textField.text != "" {
            return true
        }else{
            DispatchQueue.main.async {
                textField.placeholder = "Type Something" }
            return true
        }
        
    }
    
    // Klavye kapandıysa ve bir şey yazıldıysa yazıyı temizler
    // Yerine placeholder koyar
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchBar.text = ""
        textField.placeholder = "Search For A Food"
        self.navigationController?.isNavigationBarHidden = false
    }
}

    
