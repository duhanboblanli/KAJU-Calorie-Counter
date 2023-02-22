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
    
    @IBOutlet weak var discoverTableView: UITableView!
    @IBOutlet weak var favTableView: UITableView!
    
    @IBOutlet weak var recipesNavigationıtem: UINavigationItem!
    
    var recipes = [Recipe]()
    
    private var recipeViewModel = RecipeViewModel()
    private var images: [UIImage]?
    
    @IBOutlet weak var scrollTopButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.isNavigationBarHidden = true
        firstBottomConstraint.constant = 4.0
        secondBottomConstraint.constant = 3.0
        discoverTableView.delegate = self
        discoverTableView.dataSource = self
        favTableView.delegate = self
        favTableView.dataSource = self
        searchBar.delegate = self
        searchBar.layer.cornerRadius = searchBar.frame.size.height / 5
        recipesNavigationıtem.title = "Recipes"
        SpoonacularClient.getRandomRecipe(pagination:true,completion: handleRecipes)
       
        //loadRecipesData()
        
    }
    
    private func loadRecipesData() {
        // Called at the beginning to do an API call and fill targetRecipes
        recipeViewModel.fetchRecipeData(pagination: false){ [weak self] in
            self?.discoverTableView.dataSource = self
            self?.discoverTableView.reloadData()
        }
    } 
    
    @IBAction func refreshButtonPressed(_ sender: UIButton) {
        SpoonacularClient.getRandomRecipe(pagination:true,completion: handleRecipes)
        
        //loadRecipesData()
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
        
    }
    
    //MARK: - Handle API Response
    func handleRecipes(recipes: [Recipe], error: Error?) {
        //self.showActivityIndicator(show: false)
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
    
}// ends of RecipesViewController

//MARK: - UITableViewDelegate
extension RecipesViewController: UITableViewDelegate {
    // Seçilen cellin indexini verir
    // Datada seçilen recipe'in ingredients verisi bulunamazsa, recipe'in websitesine yönlendir
    // Bulunursa detail view'e yönlendir
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
            //navigationController?.show(detailVC, sender: self)
        }
    }
}

//MARK: - UITableViewDataSource
extension RecipesViewController: UITableViewDataSource {
    
    // Tablo görünümde kaç hücre ya da kaç satır istiyoruz burda belirtilir
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRow = 1
            switch tableView {
            case discoverTableView:
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
            case favTableView:
                numberOfRow = 1
                favoritesLabel.text = "Favorites(\(numberOfRow))"
            default:
                print("Some things Wrong RecipesTableViewDataSource!!")
            }
            return numberOfRow
    }
    
    // Belirlenen tablo cell indexinde gönderilen celli döndürür
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var recipeCell = RecipeTableViewCell() // Declare the cell
        
           switch tableView {
           case discoverTableView:
               recipeCell = tableView.dequeueReusableCell(withIdentifier: "DiscoverCell", for: indexPath) as! RecipeTableViewCell
               let recipe = recipes[indexPath.row]
               
               recipeCell.updateUI(recipe: recipe, recipeCell: recipeCell)
               
               //Edamam
              /* recipeCell = tableView.dequeueReusableCell(withIdentifier: "DiscoverCell", for: indexPath) as! RecipeTableViewCell
                 let recipe = recipeViewModel.cellForRowAt(indexPath: indexPath)
                     recipeCell.setCellWithValuesOf(recipe) */
               
           case favTableView:
               recipeCell = tableView.dequeueReusableCell(withIdentifier: "FavoritesCell", for: indexPath) as! RecipeTableViewCell
               
           default:
               print("Some things Wrong RecipesTableViewDataSource!!")
           }
        return recipeCell
    }
}

//MARK: - UITextFieldDelegate
extension RecipesViewController: UITextFieldDelegate {
    
    // Search buttona bastığında klavye kapatır
    @IBAction func searchButtonPressed(_ sender: UIButton) {

        searchBar.endEditing(true)
        //this is line of code helps to relode tableview --> eklenecek
    }
    
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
        textField.placeholder = "Search For A Recipe"
        self.navigationController?.isNavigationBarHidden = false
    }
  
}

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

    

