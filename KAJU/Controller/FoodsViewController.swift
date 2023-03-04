//
//  FoodsViewController.swift
//  KAJU
//
//  Created by Duhan Boblanlı on 14.02.2023.
//

import UIKit

class FoodsViewController: UIViewController, UpdateDelegate {
    
    func didUpdate(sender: FoodViewModel) {
        self.tableView.reloadData()
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    //For waiting alert
    var activityIndicatorContainer: UIView!
    var activityIndicator: UIActivityIndicatorView!
    
    private var foodViewModel = FoodViewModel()
    private var images: [UIImage]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        foodViewModel.delegate = self
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search For A Food", attributes: [NSAttributedString.Key.foregroundColor: UIColor( red: 170/255, green: 170/255, blue: 170/255, alpha: 1)])
        LoadFoodsData()
    }
    
    private func LoadFoodsData() {
        // Called at the beginning to do an API call and fill targetFoods
        setupActivityIndicator()
        showActivityIndicator(show: true)
        foodViewModel.fetchFoodData(pagination: false){ [weak self] in
            self?.tableView.dataSource = self
            self?.tableView.reloadData()
            self?.showActivityIndicator(show: false)
        }
    }

    // Loading alert functionality
    private func showActivityIndicator(show: Bool) {
      if show {
        DispatchQueue.main.async{
            self.tableView.allowsSelection = false
            self.activityIndicator.startAnimating()
        }
      } else {
            DispatchQueue.main.async{
                self.tableView.allowsSelection = true
                self.activityIndicator.stopAnimating()
                self.activityIndicatorContainer.removeFromSuperview()
            }
        }
    }
    
    //Loading Alert Setup
    private func setupActivityIndicator() {
        
        activityIndicatorContainer = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        activityIndicatorContainer.center.x = view.center.x
        activityIndicatorContainer.center.y = view.center.y
        activityIndicatorContainer.backgroundColor = UIColor.black
        activityIndicatorContainer.alpha = 0.8
        activityIndicatorContainer.layer.cornerRadius = 10
          
        // Configure the activity indicator
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.large
        activityIndicator.color = .white
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorContainer.addSubview(activityIndicator)
        view.addSubview(activityIndicatorContainer)
            
        // Constraints
        activityIndicator.centerXAnchor.constraint(equalTo: activityIndicatorContainer.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: activityIndicatorContainer.centerYAnchor).isActive = true
    }
} // ends of FoodsViewController

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
} // ends of extension: UIScrollViewDelegate

//MARK: - UITableViewDataSource, UITableViewDelegate
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
} // ends of extension: TableView

//MARK: - UISearchBarDelegate
extension FoodsViewController: UISearchBarDelegate {
    
    // Arama için query oluşturan fonksiyon
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchQuery = searchBar.text {
            if searchQuery != "" {
                setupActivityIndicator()
                showActivityIndicator(show: true)
                self.searchBar.placeholder = "Search Results for '\(searchQuery)' "
                foodViewModel.clearData()
                foodViewModel.fetchSearchedFoodData(searchQuery: searchQuery, pagination: false){ [weak self] in
                self?.tableView.dataSource = self
                self?.tableView.reloadData()
                self?.showActivityIndicator(show: false)
            }
                // food için query alan fonk yaz
            } else {
                DispatchQueue.main.async {
                    self.searchBar.placeholder = "Type Something!"
                }
            }
            searchBar.text = ""
            searchBar.endEditing(true)
            
        }
        self.searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.endEditing(true)
    }
    
    // Autocomplete için kullanılacak
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            self.searchBar.showsCancelButton = true
            searchBar.placeholder = "Search For A Food"
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.showsCancelButton = false
            searchBar.text = ""
            searchBar.resignFirstResponder()
    }
} // ends of extension: UISearchBarDelegate


    
