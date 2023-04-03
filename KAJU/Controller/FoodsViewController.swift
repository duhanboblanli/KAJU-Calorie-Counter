//
//  FoodsViewController.swift
//  KAJU
//
//  Created by Duhan Boblanlı on 14.02.2023.
//

import UIKit
import CoreData
import FirebaseAuth
import FirebaseFirestore


class FoodsViewController: UIViewController, UpdateDelegate {
    
    let RECENTS_LIMIT = 20
    let db = Firestore.firestore()
    
    var foodCount = 0
    
    var query = "egg"
    
    var foodType: String = "currentBreakfastCal"
    
    var searchEnable = false
    var favEnable = false
    var recentsEnable = false
    
    // 0: breakfast, 1: lunch, 2: dinner, 3: snacks
    var mealType = 0
    
    let ColorHardDarkGreen = UIColor( red: 40/255, green: 71/255, blue: 92/255, alpha: 1)
    let ColorDarkGreen = UIColor( red: 47/255, green: 136/255, blue: 134/255, alpha: 1)
    let ColorLightGreen = UIColor( red: 132/255, green: 198/255, blue: 155/255, alpha: 1)
    
    @IBOutlet weak var frequentsButtonView: UIView!
    @IBOutlet weak var recentsButtonView: UIView!
    @IBOutlet weak var favoritesButtonView: UIView!
    @IBOutlet weak var frequentsButton: UIButton!
    @IBOutlet weak var recentsButton: UIButton!
    @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet weak var frequentsLabel: UILabel!
    @IBOutlet weak var recentsLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var frequentsBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var recentsBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var favoritesBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var recentsView: UIView!
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
    
    // For favorites local foods
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    // Food lists
    var frequentFoodIdList: [String] = []
    var recentFoods: [FoodEntity] = []
    var favFoods: [FavFoodEntity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkFoodType()
        
        favoritesBottomConstraint.constant = 4.0
        recentsBottomConstraint.constant = 3.0
        favoritesBottomConstraint.constant = 3.0
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        foodViewModel.updateDelegate = self
        foodViewModel.errorDelegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "autoCompleteCell")
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search For A Food", attributes: [NSAttributedString.Key.foregroundColor: UIColor( red: 170/255, green: 170/255, blue: 170/255, alpha: 1)])
        LoadFoodsData(with: query)
        tableView.reloadData()
    }
    
    func checkFoodType(){
        if query == "egg" {
            foodType = "currentBreakfastCal"
            
        } else if query == "penne" {
            foodType = "currentLunchCal"
        }
        else if query == "fish" {
            foodType = "currentDinnerCal"
        }
        else if query == "apple" {
            foodType = "currentSnacksCal"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        setupFetchRequest()
        setupFetchRequest2()
    }
    // Fetch the local data
    private func setupFetchRequest() {
        //Recents
        let fetchRequest: NSFetchRequest<FoodEntity> = FoodEntity.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.sortDescriptors = []
        if let result = try? appDelegate.persistentContainer2.viewContext.fetch(fetchRequest) {
            recentFoods = result
            recentFoods.sort {
                $0.index < $1.index
            }
        }
        tableView.reloadData()
    }
    private func setupFetchRequest2() {
        //Favorites
        let fetchRequest2: NSFetchRequest<FavFoodEntity> = FavFoodEntity.fetchRequest()
        fetchRequest2.returnsObjectsAsFaults = false
        fetchRequest2.sortDescriptors = []
        if let result = try? appDelegate.persistentContainer3.viewContext.fetch(fetchRequest2) {
            favFoods = result
            tableView.reloadData()
        }
    }
    
    func didUpdate(sender: FoodViewModel) {
        self.tableView.reloadData()
    }
    
    private func LoadFoodsData(with searchQuery: String) {
        setupActivityIndicator()
        foodViewModel.fetchDefaultFoodData(mealType: mealType){ [weak self] in
            self?.tableView.dataSource = self
            self?.tableView.reloadData()
            self?.showActivityIndicator(show: true)
        }
        showActivityIndicator(show: true)
        // Called at the beginning to do an API call and fill targetFoods
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
    @IBAction func firstTabPressed(_ sender: UIButton) {
        self.tableView.separatorStyle = .singleLine
        tableView.setContentOffset(.zero, animated: true)
        favEnable = false
        recentsEnable = false
        frequentsBottomConstraint.constant = 4.0
        recentsBottomConstraint.constant = 3.0
        favoritesBottomConstraint.constant = 3.0
        frequentsButtonView.backgroundColor = ColorDarkGreen
        recentsButtonView.backgroundColor = ColorHardDarkGreen
        favoritesButtonView.backgroundColor = ColorHardDarkGreen
        frequentsLabel.textColor = ColorDarkGreen
        recentsLabel.textColor = UIColor.lightGray
        favoritesLabel.textColor = UIColor.lightGray
        tableView.reloadData()
    }
    @IBAction func secondTabPressed(_ sender: UIButton) {
        self.tableView.separatorStyle = .singleLine
        tableView.setContentOffset(.zero, animated: true)
        favEnable = false
        recentsEnable = true
        frequentsBottomConstraint.constant = 3.0
        recentsBottomConstraint.constant = 4.0
        favoritesBottomConstraint.constant = 3.0
        frequentsButtonView.backgroundColor = ColorHardDarkGreen
        recentsButtonView.backgroundColor = ColorDarkGreen
        favoritesButtonView.backgroundColor = ColorHardDarkGreen
        frequentsLabel.textColor = UIColor.lightGray
        recentsLabel.textColor = ColorDarkGreen
        favoritesLabel.textColor = UIColor.lightGray
        tableView.reloadData()
    }
    
    @IBAction func thirdTabPressed(_ sender: UIButton) {
        self.tableView.separatorStyle = .singleLine
        tableView.setContentOffset(.zero, animated: true)
        favEnable = true
        recentsEnable = false
        recentsBottomConstraint.constant = 3.0
        frequentsBottomConstraint.constant = 3.0
        favoritesBottomConstraint.constant = 4.0
        frequentsButtonView.backgroundColor = ColorHardDarkGreen
        recentsButtonView.backgroundColor = ColorHardDarkGreen
        favoritesButtonView.backgroundColor = ColorDarkGreen
        frequentsLabel.textColor = UIColor.lightGray
        recentsLabel.textColor = UIColor.lightGray
        favoritesLabel.textColor = ColorDarkGreen
        DispatchQueue.main.async { [self] in
            setupFetchRequest2()
        }
        
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
        if searchEnable && position > (tableView.contentSize.height-100-scrollView.frame.size.height){
            
            guard !foodViewModel.apiService.isPaginating else {
                // we are already fetching more data
                return
            }
            self.tableView.tableFooterView = createSpinnerFooter()
            foodViewModel.fetchFoodData(pagination: true){ [weak self] in
                self?.tableView.dataSource = self
                self?.tableView.reloadData()
                self?.tableView.tableFooterView = nil
            }
        }
    }
} // ends of extension: UIScrollViewDelegate

//MARK: - UITableViewDataSource, UITableViewDelegate
extension FoodsViewController: UITableViewDataSource, UITableViewDelegate, CellDelegate {
    func directAddFunction(food: FoodStruct){
        var targetCal: Int = 0
        var targetCarb: Float = 0.0
        var targetPro: Float = 0.0
        var targetFat: Float = 0.0
        navigationController?.popViewController(animated: true)
            if let calorie = food.calorie, let carbs = food.carbs, let protein = food.protein, let fat = food.fat, let wholeGram = food.wholeGram {
                var multiple = wholeGram / 100
                let calInt = Int((calorie * multiple).rounded())
                targetCal = calInt
                let carbFloat = carbs * multiple
                targetCarb = carbFloat
                let proFloat = protein * multiple
                targetPro = proFloat
                let fatFloat = fat * multiple
                targetFat = fatFloat
            }
        //Verilerin updatelenmesi(increment işlemi)
        if let currentUserEmail = Auth.auth().currentUser?.email {
             db.collection("UserInformations").document("\(currentUserEmail)").updateData([
                foodType: FieldValue.increment(Int64(targetCal)),
                "currentCarbs": FieldValue.increment(Float64(targetCarb)),
                "currentPro": FieldValue.increment(Float64(targetPro)),
                "currentFat": FieldValue.increment(Float64(targetFat))
             ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Document successfully written!")
                    }
                }
            saveActionAddToDiary(food: food)
        }
    }
    func saveActionAddToDiary(food: FoodStruct) {
        var inRecent = false
        var lastIndex = 1
        if !recentFoods.isEmpty{
            lastIndex = Int(recentFoods[recentFoods.count-1].index)
            for food2 in recentFoods{
                if food.label == food2.title{
                    inRecent = true
                    appDelegate.persistentContainer2.viewContext.delete(food2)
                }
            }
        }
        if !inRecent && recentFoods.count == RECENTS_LIMIT{
            appDelegate.persistentContainer2.viewContext.delete(recentFoods[0])
        }
        let imageData = food.image!.pngData()
        let foodEntity = FoodEntity(context: appDelegate.persistentContainer2.viewContext)
        foodEntity.title = food.label
        foodEntity.calories = Int64(food.calorie!)
        foodEntity.carbs = Int64(food.carbs!)
        foodEntity.fats = Int64(food.fat!)
        foodEntity.proteins = Int64(food.protein!)
        foodEntity.wholeGram = Int64(food.wholeGram!)
        foodEntity.measureLabel = food.measureLabel
        foodEntity.image = imageData
        foodEntity.index = Int64(lastIndex-1)
        do {
            try appDelegate.persistentContainer2.viewContext.save()
            presentAlert(title: "Food added to diary 🤩", message: "")
        } catch {
            presentAlert(title: "Unable to add food", message: "")
        }
    }
    func directAddTap(_ cell: FoodTableViewCell) {
        let index = self.tableView.indexPath(for: cell)
        var food: FoodStruct
        if favEnable && !searchEnable && foodSearchSuggestions.count == 0{
            food = fitTheFood2(foodTarget: favFoods[index!.row])
        }
        else if recentsEnable && !searchEnable && foodSearchSuggestions.count == 0{
            food = fitTheFood(foodTarget: recentFoods[index!.row])
        }
        else if !searchEnable && foodSearchSuggestions.count == 0{
            food = foodViewModel.frequentFoods[index!.row]
        }
        else{
            food = foodViewModel.cellForRowAt(indexPath: index!)
        }
        directAddFunction(food: food)
    }
    
    
    func fitTheFood(foodTarget: FoodEntity)->FoodStruct{
        let food = FoodStruct(label: foodTarget.title, calorie: Float(foodTarget.calories), image: UIImage(data: foodTarget.image!), carbs: Float(foodTarget.carbs), fat: Float(foodTarget.fats), protein: Float(foodTarget.proteins), wholeGram: Float(foodTarget.wholeGram), measureLabel: foodTarget.measureLabel)
        return food
    }
    func fitTheFood2(foodTarget: FavFoodEntity)->FoodStruct{
        let food = FoodStruct(label: foodTarget.title, calorie: Float(foodTarget.calories), image: UIImage(data: foodTarget.image!), carbs: Float(foodTarget.carbs), fat: Float(foodTarget.fats), protein: Float(foodTarget.proteins), wholeGram: Float(foodTarget.wholeGram), measureLabel: foodTarget.measureLabel)
        return food
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var food: FoodStruct
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "FoodDetailVC") as! FoodDetailVC
        if foodSearchSuggestions.count == 0{
            if favEnable && !searchEnable{
                food = fitTheFood2(foodTarget: favFoods[indexPath.row])
            }
            else if recentsEnable && !searchEnable{
                food = fitTheFood(foodTarget: recentFoods[indexPath.row])
            }
            else if !searchEnable{
                food = foodViewModel.frequentFoods[indexPath.row]
            }
            else{
                food = foodViewModel.cellForRowAt(indexPath: indexPath)
            }
            nextViewController.favFoods = favFoods
            nextViewController.food = food
            nextViewController.query = self.query
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
        else {
            searchBar.text = foodSearchSuggestions[indexPath.row]
            self.searchBarSearchButtonClicked(self.searchBar)
            tableView.reloadData()
        }
    }
    
    // Tablo görünümde kaç hücre ya da kaç satır istiyoruz burda belirtilir
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRow = 1
        
        if favEnable && !searchEnable && foodSearchSuggestions.count == 0{
            numberOfRow = favFoods.count
            if numberOfRow != 0 {
                tableView.restore()
            }
            else {
                tableView.setEmptyView(title: "You don't have any saved favorite foods.", message: "Your saved favorite foods will be in here.")
            }
            print("favEnabled: ", numberOfRow.description)
        }
        else if recentsEnable && !searchEnable && foodSearchSuggestions.count == 0{
            numberOfRow = recentFoods.count
            if numberOfRow != 0 {
                tableView.restore()
            }
            else {
                tableView.setEmptyView(title: "You don't have any foods you added to diary.", message: "Your recent foods that added to diary will be in here.")
            }
        }
        else if !searchEnable && foodSearchSuggestions.count == 0{
            numberOfRow = foodViewModel.frequentFoods.count
        }
        else if searchEnable {
            numberOfRow = foodViewModel.numberOfRowsInSection(section: section)
        }
        else {
            numberOfRow = foodSearchSuggestions.count
        }
        return numberOfRow
    }
    
    
    // Belirlenen tablo cell indexinde gönderilen celli döndürür
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if favEnable && !searchEnable && foodSearchSuggestions.count == 0{
            var foodCell : FoodTableViewCell // Declare the cell
            foodCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FoodTableViewCell // Initialize cell
            let food = fitTheFood2(foodTarget: favFoods[indexPath.row])
            foodCell.setCellWithValuesOf(food)
            foodCell.separatorInset.bottom = tableView.bounds.size.width
            foodCell.buttonAdded()
            foodCell.delegate = self
            return foodCell
        }
        else if recentsEnable && !searchEnable && foodSearchSuggestions.count == 0{
            
            var foodCell : FoodTableViewCell // Declare the cell
            foodCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FoodTableViewCell // Initialize cell
            let food = fitTheFood(foodTarget: recentFoods[indexPath.row])
            foodCell.setCellWithValuesOf(food)
            foodCell.separatorInset.bottom = tableView.bounds.size.width
            foodCell.buttonAdded()
            foodCell.delegate = self
            return foodCell
            
        }
        else if !searchEnable && foodSearchSuggestions.count == 0{
            var foodCell : FoodTableViewCell // Declare the cell
            foodCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FoodTableViewCell // Initialize cell
            let food = foodViewModel.frequentFoods[indexPath.row]
            foodCell.setCellWithValuesOf(food)
            foodCell.separatorInset.bottom = tableView.bounds.size.width
            foodCell.buttonAdded()
            foodCell.delegate = self
            return foodCell
        }
        else if searchEnable {
            var foodCell : FoodTableViewCell // Declare the cell
            foodCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FoodTableViewCell // Initialize cell
            let food = foodViewModel.cellForRowAt(indexPath: indexPath)
            foodCell.setCellWithValuesOf(food)
            foodCell.separatorInset.bottom = tableView.bounds.size.width
            foodCell.buttonAdded()
            foodCell.delegate = self
            return foodCell
            
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "autoCompleteCell")!
            self.tableView.separatorStyle = .singleLine
            cell.contentView.backgroundColor = UIColor( red: 26/255, green: 47/255, blue: 75/255, alpha: 1)
            cell.textLabel?.numberOfLines = 1
            cell.textLabel?.font = UIFont(name: "Verdana", size: 16)
            cell.textLabel?.textColor = .lightGray
            cell.textLabel?.text = foodSearchSuggestions[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !searchEnable && foodSearchSuggestions.count == 0{
            return 100
        }
        else if favEnable && !searchEnable && foodSearchSuggestions.count == 0{
            return 100
        }
        else if recentsEnable && !searchEnable && foodSearchSuggestions.count == 0{
            return 100
        }
        else if searchEnable {
            return 100
        }
        else{
            return 35
        }
    }
    
    // Sola kaydırarak silme işlevi
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        var action = UISwipeActionsConfiguration()
        if favEnable && !searchEnable{
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
                let foodToDelete = self.favFoods[indexPath.row]
                self.appDelegate.persistentContainer3.viewContext.delete(foodToDelete)
                try? self.appDelegate.persistentContainer3.viewContext.save()
                self.favFoods.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                completionHandler(true)
            }
            action =  UISwipeActionsConfiguration(actions: [deleteAction])
        }
        return action
    }
        

} // ends of extension: TableView

//MARK: - UISearchBarDelegate
extension FoodsViewController: UISearchBarDelegate, ErrorDelegate {
    func didError(sender: FoodViewModel) {
        showActivityIndicator(show: false)
        DispatchQueue.main.async {
            self.foodSearchSuggestions = []
            self.searchEnable = false
            self.tableView.reloadData()
        }
        //searchEnable = false
        //self.searchBar.placeholder = "Search For A Food"
        //searchBarCancelButtonClicked(self.searchBar)
        //tableView.reloadData()
    }
    
    
    // Arama için query oluşturan fonksiyon
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if favEnable{
            favoritesLabel.text = "Search"
        }
        else if recentsEnable{
            recentsLabel.text = "Search"
        }
        else{
            frequentsLabel.text = "Search"
        }
        searchEnable = true
        searchBar.setShowsCancelButton(true, animated: true)
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
                    self.searchBar.placeholder = "Search For A Food!"
                }
            }
            searchBar.text = ""
            searchBar.endEditing(true)
        }
        searchBar.text = ""
        searchBar.endEditing(true)
    }
    
    
    // Autocomplete için kullanılacak
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       
            if searchText.count > 0 {
                //searchEnable = true
                currentSearchTask?.cancel()
                currentSearchTask = foodViewModel.autoCompleteFoodSearch(searchQuery: searchText) { (foodSearchSuggestions, error) in
                    self.foodSearchSuggestions = foodSearchSuggestions
                    print("foodSearchSuggestions:",self.foodSearchSuggestions)
                    if foodSearchSuggestions.isEmpty{
                        //self.searchEnable = false
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                currentSearchTask?.resume()
            }
            else {
                currentSearchTask?.cancel()
                //searchEnable = false
                foodSearchSuggestions = []
                tableView.reloadData()
            }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.placeholder = "Search For A Food"
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        if favEnable{
            favoritesLabel.text = "Favorites"
        }
        else if recentsEnable{
            recentsLabel.text = "Recents"
        }
        else{
            frequentsLabel.text = "Frequents"
        }
        searchBar.resignFirstResponder()
        searchEnable = false
        foodSearchSuggestions = []
        searchBar.setShowsCancelButton(false, animated: true)
        tableView.reloadData()
    }
} // ends of extension: UISearchBarDelegate


    
