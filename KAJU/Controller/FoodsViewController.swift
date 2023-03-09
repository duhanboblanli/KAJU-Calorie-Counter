//
//  FoodsViewController.swift
//  KAJU
//
//  Created by Duhan Boblanlı on 14.02.2023.
//

import UIKit

class FoodsViewController: UIViewController, UpdateDelegate {
    
    var query = "egg"
    
    @IBOutlet weak var tableView: UITableView!
    //For search and autoComplete
    @IBOutlet weak var searchBar: UISearchBar!
    var foodSearchSuggestions = [String]()
    var currentSearchTask: URLSessionTask?
    
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "autoCompleteCell")
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search For A Food", attributes: [NSAttributedString.Key.foregroundColor: UIColor( red: 170/255, green: 170/255, blue: 170/255, alpha: 1)])
        LoadFoodsData(with: query)
    }
    
    func didUpdate(sender: FoodViewModel) {
        self.tableView.reloadData()
    }
    
    private func LoadFoodsData(with searchQuery: String) {
        // Called at the beginning to do an API call and fill targetFoods
        setupActivityIndicator()
        showActivityIndicator(show: true)
        foodViewModel.fetchSearchedFoodData(searchQuery:searchQuery,pagination: false){ [weak self] in
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
                self?.tableView.tableFooterView = nil
                self?.tableView.dataSource = self
                self?.tableView.reloadData()
            }
        }
    }
} // ends of extension: UIScrollViewDelegate

//MARK: - UITableViewDataSource, UITableViewDelegate
extension FoodsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if foodSearchSuggestions.count == 0 {
            let food = foodViewModel.cellForRowAt(indexPath: indexPath)
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "FoodDetailVC") as! FoodDetailVC
            nextViewController.food = food
            nextViewController.query = self.query
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        }
        else {
            searchBar.text = foodSearchSuggestions[indexPath.row]
            foodSearchSuggestions = []
            tableView.reloadData()
        }
    }
    
    // Tablo görünümde kaç hücre ya da kaç satır istiyoruz burda belirtilir
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRow = 1
        if foodSearchSuggestions.count == 0 {
            numberOfRow = foodViewModel.numberOfRowsInSection(section: section)
        }
        else {
            numberOfRow = foodSearchSuggestions.count
        }
            return numberOfRow
    }
    
    // Belirlenen tablo cell indexinde gönderilen celli döndürür
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if foodSearchSuggestions.count == 0 {
            var foodCell : FoodTableViewCell // Declare the cell
            foodCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FoodTableViewCell // Initialize cell
            let food = foodViewModel.cellForRowAt(indexPath: indexPath)
            foodCell.setCellWithValuesOf(food)
            return foodCell
            
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "autoCompleteCell")!
            
            cell.contentView.backgroundColor = UIColor( red: 26/255, green: 47/255, blue: 75/255, alpha: 1)
            cell.textLabel?.numberOfLines = 1
            cell.textLabel?.font = UIFont(name: "Verdana", size: 16)
            cell.textLabel?.textColor = .lightGray
            cell.textLabel?.text = foodSearchSuggestions[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if foodSearchSuggestions.count == 0 {
                return 100
            }else {
                return 35
            }
        }

} // ends of extension: TableView

//MARK: - UISearchBarDelegate
extension FoodsViewController: UISearchBarDelegate {
    
    // Arama için query oluşturan fonksiyon
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let searchQuery = searchBar.text {
            if searchQuery != "" {
                foodSearchSuggestions = []
                self.searchBar.placeholder = "Search Results for '\(searchQuery)' "
                foodViewModel.clearData()
                var configuretedQuery = searchQuery.replacingOccurrences(of: ",", with: "%2C", options: .literal, range: nil)
                configuretedQuery = searchQuery.replacingOccurrences(of: " ", with: "%2C", options: .literal, range: nil)
                LoadFoodsData(with: configuretedQuery)
            } else {
                DispatchQueue.main.async {
                    self.searchBar.placeholder = "Type Something!"
                }
            }
            searchBar.text = ""
            searchBar.endEditing(true)
        }
//        showActivityIndicator(show: false)
        self.searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.endEditing(true)
    }
    
    // Autocomplete için kullanılacak
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       
            if searchText.count >= 3 {
                currentSearchTask?.cancel()
                currentSearchTask = foodViewModel.autoCompleteFoodSearch(searchQuery: searchText) { (foodSearchSuggestions, error) in
                    self.foodSearchSuggestions = foodSearchSuggestions
                    print("foodSearchSuggestions:",self.foodSearchSuggestions)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                currentSearchTask?.resume()
            }
            else {
                foodSearchSuggestions = []
                tableView.reloadData()
            }
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


    
