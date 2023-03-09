//
//  RecipesViewController.swift
//  KAJU
//
//  Created by Duhan Boblanlı on 15.02.2023.
//

import UIKit
import CoreData

class RecipesViewController: UIViewController, UISearchBarDelegate {
    
    // Bunlar diğer sayfalardakinden farklı, değiştirme!
    let ColorHardDarkGreen = UIColor( red: 40/255, green: 71/255, blue: 92/255, alpha: 1)
    let ColorDarkGreen = UIColor( red: 47/255, green: 136/255, blue: 134/255, alpha: 1)
    let ColorLightGreen = UIColor( red: 132/255, green: 198/255, blue: 155/255, alpha: 1)
    // For Discover/Favorites Pagination
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
    // For search
    @IBOutlet weak var searchBar: UITextField!
    var recipeSearchSuggestions = [AutoCompleteSearchResponse]()
    var currentSearchTask: URLSessionTask?
    var newSearchedRecipes = [Recipe]()
    // UISearchBar
    @IBOutlet weak var orginSearchBar: UISearchBar!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var discoverTableView: UITableView!
    @IBOutlet weak var favTableView: UITableView!
    @IBOutlet weak var recipesNavigationıtem: UINavigationItem!
    @IBOutlet weak var scrollTopButton: UIButton!
    
    //For waiting alert
    var activityIndicatorContainer: UIView!
    var activityIndicator: UIActivityIndicatorView!
    
    // For random discover recipes
    var recipes = [Recipe]()
    
    // For favorites local recipes
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var foodRecipes: [FoodRecipe] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        setupFetchRequest()
    }
    
    //Localdaki verileri çek
    private func setupFetchRequest() {
        let fetchRequest: NSFetchRequest<FoodRecipe> = FoodRecipe.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.sortDescriptors = []
        if let result = try? appDelegate.persistentContainer.viewContext.fetch(fetchRequest) {
            foodRecipes = result
            favTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstBottomConstraint.constant = 4.0
        secondBottomConstraint.constant = 3.0
        discoverTableView.delegate = self
        discoverTableView.dataSource = self
        favTableView.delegate = self
        favTableView.dataSource = self
        searchBar.delegate = self
        searchBar.layer.cornerRadius = searchBar.frame.size.height / 5
        discoverTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        recipesNavigationıtem.title = "Recipes"
    }
    
    override func loadView() {
        super.loadView()
        setupActivityIndicator()
        showActivityIndicator(show: true)
        SpoonacularClient.getRandomRecipe(pagination:true,completion: handleRecipes)
    }
    
    // Eşzamanlı searchTextFielddan text çekme
    // 3.harf ve sonrası autoComplete tableView reload eder
    @IBAction func searchBarTextDidChange(_ sender: UITextField) {
        if let searchText = sender.text {
            if searchText.count >= 3 {
                discoverTableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
                discoverTableView.separatorColor = ColorLightGreen
                scrollTopButton.isHidden = true
                currentSearchTask?.cancel()
                currentSearchTask = SpoonacularClient.autoCompleteRecipeSearch(query: searchText) { (recipeSearchSuggestions, error) in
                    self.recipeSearchSuggestions = recipeSearchSuggestions
                    DispatchQueue.main.async {
                        self.discoverTableView.reloadData()
                    }
                }
                currentSearchTask?.resume()
            }
            else {
                discoverTableView.separatorStyle = .none
                scrollTopButton.isHidden = false
                recipeSearchSuggestions = []
                discoverTableView.reloadData()
            }
        }
    }
    
    @IBAction func refreshButtonPressed(_ sender: UIButton) {
        setupActivityIndicator()
        showActivityIndicator(show: true)
        newSearchedRecipes = []
        SpoonacularClient.getRandomRecipe(pagination:true,completion: handleRecipes)
        //SpoonacularClient.newSearch(query: "chicken", completion: handleSearchRecipes)
        DispatchQueue.main.async {
            self.searchBar.placeholder = "Discover from Random Recipes!"
        }
        discoverTableView.reloadData()
    }
    
    // Loading alert functionality
    private func showActivityIndicator(show: Bool) {
      if show {
        DispatchQueue.main.async{
            self.discoverTableView.allowsSelection = false
            self.activityIndicator.startAnimating()
            self.refreshButton.isEnabled = false
        }
      } else {
            DispatchQueue.main.async{
                self.discoverTableView.allowsSelection = true
                self.refreshButton.isEnabled = true
                self.activityIndicator.stopAnimating()
                self.activityIndicatorContainer.removeFromSuperview()
            }
        }
    }
    
    //Loading Alert Setup
    private func setupActivityIndicator() {
        
        activityIndicatorContainer = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        activityIndicatorContainer.center.x = view.center.x
        activityIndicatorContainer.center.y = view.center.y
        activityIndicatorContainer.backgroundColor = UIColor.black
        activityIndicatorContainer.alpha = 0.7
        activityIndicatorContainer.layer.cornerRadius = 10
          
        // Configure the activity indicator
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        activityIndicator.color = .white
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorContainer.addSubview(activityIndicator)
        view.addSubview(activityIndicatorContainer)
            
        // Constraints
        activityIndicator.centerXAnchor.constraint(equalTo: activityIndicatorContainer.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: activityIndicatorContainer.centerYAnchor).isActive = true
    }
    
    @IBAction func scrollToTopButtonPressed(_ sender: UIButton) {
        discoverTableView.scrollToTop(animated: true)
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
        DispatchQueue.main.async { [self] in
            setupFetchRequest()
        }
        
    }
    
    //MARK: - Handle API Response
    // For random recipes API call
    func handleRecipes(recipes: [Recipe], error: Error?) {
        self.showActivityIndicator(show: false)
        if let error = error {
            DispatchQueue.main.async {
                self.presentAlert(title: error.localizedDescription, message: "")
            }
        }
        self.recipes = recipes
        DispatchQueue.main.async {
            self.discoverTableView.reloadData()
        }
    }
    
    // For search recipes API call
    func handleSearchRecipes(recipes: [Recipe], error: Error?) {
        self.showActivityIndicator(show: false)
        if let error = error {
            DispatchQueue.main.async {
                self.presentAlert(title: error.localizedDescription, message: "")
            }
        }
        self.newSearchedRecipes = recipes
        DispatchQueue.main.async {
            self.discoverTableView.reloadData()
        }
    }
    
}// ends of RecipesViewController

//MARK: - UITableViewDelegate
extension RecipesViewController: UITableViewDelegate {
    // Seçilen cellin indexini verir
    // Datada seçilen recipe'in ingredients verisi bulunamazsa, recipe'in websitesine yönlendir
    // Bulunursa detail view'e yönlendir
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if recipeSearchSuggestions.count == 0 {
            switch tableView {
            case discoverTableView:
                if newSearchedRecipes.count == 0 {
                    let recipe = recipes[indexPath.row]
                    if recipe.ingredients?.count == 0 {
                        if let url = URL(string: recipe.sourceURL ?? "") {
                            if UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            } else {
                                self.presentAlert(title: "Recipe Unavailable", message: "")
                            }
                        } else {
                            self.presentAlert(title: "Recipe Unavailable", message: "")
                        }
                    } else {
                        let detailVC = DetailViewController()
                        detailVC.recipe = recipe
                        navigationController?.pushViewController(detailVC, animated: true)
                    }
                }
                else {
                    let recipe = newSearchedRecipes[indexPath.row]
                    if recipe.ingredients?.count == 0 {
                        if let url = URL(string: recipe.sourceURL ?? "") {
                            if UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            } else {
                                self.presentAlert(title: "Recipe Unavailable", message: "")
                            }
                        } else {
                            self.presentAlert(title: "Recipe Unavailable", message: "")
                        }
                    } else {
                        let detailVC = DetailViewController()
                        detailVC.recipe = recipe
                        navigationController?.pushViewController(detailVC, animated: true)
                    }
                }
            case favTableView:
                let foodRecipe = foodRecipes[indexPath.row]
                if foodRecipe.ingredients!.count == 0 {
                    if let url = URL(string: foodRecipe.sourceURL ?? "") {
                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        } else {
                            self.presentAlert(title: "Recipe Unavailable", message: "")
                        }
                    } else {
                        self.presentAlert(title: "Recipe Unavailable", message: "")
                    }
                } else {
                    let detailVC = DetailViewController()
                    detailVC.foodRecipe = foodRecipes[indexPath.row]
                    self.navigationController?.pushViewController(detailVC, animated: true)
                }
                
            default:
                print("Some things Wrong Recipes didSelectRowAt!!")
            }
        }
        else {
            searchBar.text = recipeSearchSuggestions[indexPath.row].title
            recipeSearchSuggestions = []
            discoverTableView.separatorStyle = .none
            discoverTableView.reloadData()
        }
    }
    
    // Sola kaydırarak silme işlevi
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        var action = UISwipeActionsConfiguration()
        if tableView == favTableView {
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
                let recipeToDelete = self.foodRecipes[indexPath.row]
                self.appDelegate.persistentContainer.viewContext.delete(recipeToDelete)
                try? self.appDelegate.persistentContainer.viewContext.save()
                self.foodRecipes.remove(at: indexPath.row)
                self.favTableView.deleteRows(at: [indexPath], with: .automatic)
                completionHandler(true)
            }
            action =  UISwipeActionsConfiguration(actions: [deleteAction])
        }
        return action
    }
} // ends of extension:UITableViewDelegate

//MARK: - UITableViewDataSource
extension RecipesViewController: UITableViewDataSource {
    
    // Tablo görünümde kaç hücre ya da kaç satır istiyoruz?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRow = 1
        if recipeSearchSuggestions.count == 0 {
            switch tableView {
            case discoverTableView:
                
                if newSearchedRecipes.count == 0 {
                    numberOfRow = recipes.count
                    if recipes.count <= 1 {
                        scrollTopButton.isEnabled = false
                        scrollTopButton.isHidden = true
                    }
                    else {
                        scrollTopButton.isEnabled = true
                        scrollTopButton.isHidden = false
                    }
                    //Edamam
                    //numberOfRow = recipeViewModel.numberOfRowsInSection(section: section)
                    return numberOfRow
                }
                else {
                    numberOfRow = newSearchedRecipes.count
                }
                
            case favTableView:
                numberOfRow = foodRecipes.count
                if numberOfRow != 0 {
                    favoritesLabel.text = "Favorites(\(numberOfRow))"
                    favTableView.restore()
                }
                else {
                    favoritesLabel.text = "Favorites"
                    favTableView.setEmptyView(title: "You don't have any saved favorite recipes.", message: "Your saved recipes will be in here.")
                }
            default:
                print("Some things Wrong RecipesTableViewDataSource!!")
            }
        }
        else {
            numberOfRow = recipeSearchSuggestions.count
        }
            return numberOfRow
    }
    
    // Belirlenen tablo cell indexinde gönderilen celli döndürür
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if recipeSearchSuggestions.count == 0 {
            if tableView == discoverTableView {
                discoverTableView.rowHeight = 375
                if newSearchedRecipes.count == 0 {
                    var recipeCell = RecipeTableViewCell()
                    recipeCell = tableView.dequeueReusableCell(withIdentifier: "DiscoverCell", for: indexPath) as! RecipeTableViewCell
                    
                    let recipe = recipes[indexPath.row]
                    recipeCell.updateUI(recipe: recipe, recipeCell: recipeCell)
                    return recipeCell
                } else {
                    var recipeCell = RecipeTableViewCell()
                    recipeCell = tableView.dequeueReusableCell(withIdentifier: "DiscoverCell", for: indexPath) as! RecipeTableViewCell
                    
                    let recipe = newSearchedRecipes[indexPath.row]
                    recipeCell.updateUI(recipe: recipe, recipeCell: recipeCell)
                    return recipeCell
                }
            }else {
                favTableView.rowHeight = 375
                var recipeCell = FavoritesCell()
                recipeCell = favTableView.dequeueReusableCell(withIdentifier: "FavoritesCell", for: indexPath) as! FavoritesCell
                let foodRecipe = foodRecipes[indexPath.row]
                recipeCell.updateFoodUI(recipe: foodRecipe, recipeCell: recipeCell)
                return recipeCell
            }
        }
    else {
        discoverTableView.rowHeight = 35
        let cell = discoverTableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.contentView.backgroundColor = UIColor( red: 26/255, green: 47/255, blue: 75/255, alpha: 1)
        cell.textLabel?.numberOfLines = 1
        cell.textLabel?.font = UIFont(name: "Verdana", size: 16)
        cell.textLabel?.textColor = .lightGray
        cell.textLabel?.text = recipeSearchSuggestions[indexPath.row].title
        return cell
        }
    }
} // ends of extension:UITableViewDataSource

//MARK: - UITextFieldDelegate
extension RecipesViewController: UITextFieldDelegate {
    // Search buttona bastığında klavye kapatır
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        if let searchQuery = searchBar.text {
            if searchQuery != "" {
                setupActivityIndicator()
                showActivityIndicator(show: true)
                self.searchBar.placeholder = "Search Results for '\(searchQuery)' "
                SpoonacularClient.newSearch(query: searchQuery, completion: handleSearchRecipes)
            } else {
                DispatchQueue.main.async {
                    self.searchBar.placeholder = "Type Something!"
                }
            }
            searchBar.text = ""
            searchBar.endEditing(true)
        }
    }
    // Klavyeden returne bastığında klavye kapatır
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let searchQuery = searchBar.text {
            if searchQuery != "" {
                setupActivityIndicator()
                showActivityIndicator(show: true)
                self.searchBar.placeholder = "Search Results for '\(searchQuery)' "
                SpoonacularClient.newSearch(query: searchQuery, completion: handleSearchRecipes)
            } else {
                DispatchQueue.main.async {
                    self.searchBar.placeholder = "Type Something!"
                }
            }
            searchBar.text = ""
            searchBar.endEditing(true)
        }
        searchBar.text = ""
        searchBar.endEditing(true)
        return true
    }
    
    // Klavye kapandıysa ve bir şey yazılmadıysa yerine placeholder koyar
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return false
        }else{
            return true
        }
    }

    // Klavye kapandıysa ve bir şey yazıldıysa yazıyı temizler
    // Yerine placeholder koyar
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchBar.text = ""
        //textField.placeholder = "Search For A Recipe"
        self.navigationController?.isNavigationBarHidden = false
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = "Search For A Recipe"
    }

} // ends of extension:UITextFieldDelegate

/*//MARK: - UIScrollViewDelegate - request sayısı yetersiz açma!
extension RecipesViewController: UIScrollViewDelegate{
    
    // Pagination beklenirken loading animasyonu yarat
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
        if position > (discoverTableView.contentSize.height-100-scrollView.frame.size.height){
            print("fetch more")
            
            
            // Spoonacular
           /* guard !SpoonacularClient.isPaginating else {
                print("111we are already fetching more data")
                return
            }
            self.discoverTableView.tableFooterView = createSpinnerFooter()
            SpoonacularClient.getRandomRecipe(pagination:true,completion: handleRecipes)
            self.discoverTableView.tableFooterView = nil
            
            guard SpoonacularClient.isPaginating else {
                print("222we are already fetching more data")
                 return
             } */
             

            
            /* //Edamam
            guard !recipeViewModel.apiService.isPaginating else {
                            // we are already fetching more data
                            return
                        }
            self.discoverTableView.tableFooterView = createSpinnerFooter()
            recipeViewModel.fetchRecipeData(pagination: true){ [weak self] in
                self?.discoverTableView.reloadData()
                print("load more")
                self?.discoverTableView.tableFooterView = nil }
                
             */
        }
    }
} */

    

