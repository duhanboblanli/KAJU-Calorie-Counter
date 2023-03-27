//
//  DetailViewController.swift
//  KAJU
//
//  Created by Duhan Boblanlı on 22.02.2023.
//

import UIKit
import CoreData
import Foundation

class DetailViewController: UIViewController {
    
    let ColorHardDarkGreen = UIColor( red: 26/255, green: 47/255, blue: 75/255, alpha: 1) //rgb(26, 47, 75)
    let ColorDarkGreen = UIColor( red: 40/255, green: 71/255, blue: 92/255, alpha: 1) //rgb(40, 71, 92)
    let ColorGreen = UIColor( red: 47/255, green: 136/255, blue: 134/255, alpha: 1) //rgb(47, 136, 134)
    let ColorLightGreen = UIColor( red: 132/255, green: 198/255, blue: 155/255, alpha: 1) //rgb(132, 198, 155)
    let ColorOrange = UIColor( red: 255/255, green: 56/255, blue: 51/255, alpha: 1)
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var recipe: Recipe!
    var ingredientsArray = [String]()
    var ingredients = [Ingredient]() // Type, local databasede tanımlı; detail viewde tıklanan recipe
    var image = UIImage()
    var isSavedRecipe = false
    var foodRecipe: FoodRecipe! // Type, local databasede tanımlı; detail viewde tıklanan recipe
    let instructionsButton = UIButton()
    let addToDiaryButton = UIButton()
    let tableView = UITableView.init(frame: CGRect.zero, style: .grouped)
    // For favorites
    var isFav = false
    var favoriteRecipes: [FoodRecipe] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Recipe local databasede kayıtlı mı ?
        // Kayıtlıysa ingredientsleri burdan al
        if foodRecipe != nil {
            isSavedRecipe = true
            setupFetchRequest()
            return
        }
        // Recip ingredientsleri networking ile al
        if let ingredients = recipe.ingredients {
            self.ingredientsArray = ingredients
        }
        getFavorites()
        favoriteAction()
    }
    //Localdaki verileri çek
    private func getFavorites() {
        let fetchRequest: NSFetchRequest<FoodRecipe> = FoodRecipe.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.sortDescriptors = []
        if let result = try? appDelegate.persistentContainer.viewContext.fetch(fetchRequest) {
            favoriteRecipes = result
        }
    }
   
    // Localdaki datanın ingredientsleri alır
    // Ingredients tableView'i bununla updateler
    // Saved sayfasından detailse basarsan çağrılır
    private func setupFetchRequest() {
        let fetchRequest: NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        let predicate = NSPredicate(format: "foodRecipe == %@", foodRecipe)
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate = predicate
        if let result = try? appDelegate.persistentContainer.viewContext.fetch(fetchRequest) {
            ingredients = result
            tableView.reloadData()
        }
    }
    
    // viewDidLoad'da çağrılır
    func favoriteAction(){
        
        for fav in favoriteRecipes {
            if fav.title == recipe.title {
                isFav = true
            }
        }
        if isFav {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Favorited", style: .plain, target: self, action: #selector(self.unfavorite(_:)))
        }
        else{
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Favorite", style: .plain, target: self, action: #selector(self.favorite(_:)))
        }
    }
    // Change the button label and action if clicked
    @objc func favorite(_ sender: UITapGestureRecognizer) {
        isFav = true
        navigationItem.rightBarButtonItem?.title = "Favorited"
        saveAction()
        navigationItem.rightBarButtonItem?.action = #selector(self.unfavorite(_:))
    }
    
    @objc func unfavorite(_ sender: UITapGestureRecognizer) {
        isFav = false
        navigationItem.rightBarButtonItem?.title = "Favorite"
        getFavorites()
        for fav in favoriteRecipes {
            if fav.title == recipe.title { //|| fav.title == foodRecipe.title
                self.appDelegate.persistentContainer.viewContext.delete(fav)
                try? self.appDelegate.persistentContainer.viewContext.save()
                self.favoriteRecipes.remove(at: favoriteRecipes.firstIndex(of: fav)!)
            }
        }
        navigationItem.rightBarButtonItem?.action = #selector(self.favorite(_:))
    }
  
    
    //MARK: - Setup View
    override func loadView() {
        super.loadView()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = ColorHardDarkGreen
        setupAddToDiaryButton()
        setupInstructionButton()
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 85.0
        tableView.rowHeight = UITableView.automaticDimension
        view.addSubview(tableView)
        // Default tableView Cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: instructionsButton.topAnchor, constant: 0).isActive = true
        tableView.backgroundColor = ColorHardDarkGreen
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        tableView.separatorColor = ColorLightGreen
    }
    
    
    private func setupInstructionButton() {
        view.addSubview(instructionsButton)
        instructionsButton.translatesAutoresizingMaskIntoConstraints = false
        instructionsButton.trailingAnchor.constraint(equalTo: addToDiaryButton.trailingAnchor, constant: -54).isActive = true
        instructionsButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 0).isActive = true
        instructionsButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor,constant: -4).isActive = true
        //instructionsButton.bottomAnchor.constraint(equalTo: addToDiaryButton.topAnchor, constant: 0).isActive = true
        instructionsButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        //instructionsButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        instructionsButton.layer.cornerRadius = 11
        instructionsButton.layer.borderWidth = 0.3
        instructionsButton.setTitle("Instructions", for: .normal)
        instructionsButton.setTitleColor(.white, for: .normal)
        instructionsButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18.5)
        instructionsButton.backgroundColor = ColorGreen
        instructionsButton.addTarget(self, action: #selector(showInstructionsAction), for: .touchUpInside)
    }
    private func setupAddToDiaryButton() {
        view.addSubview(addToDiaryButton)
        addToDiaryButton.translatesAutoresizingMaskIntoConstraints = false
        addToDiaryButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: 0).isActive = true
       //addToDiaryButton.leadingAnchor.constraint(equalTo: instructionsButton.leadingAnchor, constant: 0).isActive = true
        addToDiaryButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor,constant: -4).isActive = true
        addToDiaryButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        addToDiaryButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        addToDiaryButton.layer.cornerRadius = 11
        addToDiaryButton.layer.borderWidth = 0.3
        addToDiaryButton.setTitle("➕", for: .normal)
        addToDiaryButton.setTitleColor(.white, for: .normal)
        addToDiaryButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18.5)
        addToDiaryButton.backgroundColor = ColorGreen
        addToDiaryButton.addTarget(self, action: #selector(addToDiaryAction), for: .touchUpInside)
    }
    
    // Save buttona daha basılmamışsa bu action'ı sağlayan buton yarat
    // Networkingden gelen datayı local database'e kaydet
    @objc func saveAction() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let imageData = image.pngData()
        let foodRecipe = FoodRecipe(context: appDelegate.persistentContainer.viewContext)
        foodRecipe.title = recipe.title
        foodRecipe.sourceURL = recipe.sourceURL
        foodRecipe.timeRequired = Int64(recipe.timeRequired!)
        foodRecipe.calories = Int64(recipe.calories!)
        foodRecipe.carbs = Int64(recipe.carbs!)
        foodRecipe.fats = Int64(recipe.fat!)
        foodRecipe.proteins = Int64(recipe.protein!)
        foodRecipe.image = imageData
        
        if ingredientsArray.count != 0 {
            for ingredientString in ingredientsArray {
                let ingredient = Ingredient(context: appDelegate.persistentContainer.viewContext)
                ingredient.ingredient = ingredientString
                ingredient.foodRecipe = foodRecipe
            }
        } else {
            foodRecipe.ingredients = []
        }
        
        if let instructions = recipe.instructions {
            if instructions.count != 0 {
                var count = 1
                for instructionString in instructions {
                    let instruction = Instruction(context: appDelegate.persistentContainer.viewContext)
                    instruction.instruction = instructionString
                    instruction.foodRecipe = foodRecipe
                    instruction.stepNumber = Int64(count)
                    count += 1
                }
            } else {
                foodRecipe.instructions = []
            }
        }
        do {
            try appDelegate.persistentContainer.viewContext.save()
            presentAlert(title: "Recipe Favorited 🤩", message: "")
        } catch {
            presentAlert(title: "Unable to Save the Recipe", message: "")
        }
    }
    func fitTheFood(recipeTarget: FoodRecipe)->FoodStruct{
        let food = FoodStruct(label: recipeTarget.title, calorie: Float(recipeTarget.calories), image: UIImage(data: foodRecipe.image!), carbs: Float(recipeTarget.carbs), fat: Float(recipeTarget.fats), protein: Float(recipeTarget.proteins), wholeGram: 0.0, measureLabel: "")
        return food
    }
    @objc func addToDiaryAction() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "FoodDetailVC") as! FoodDetailVC
        nextViewController.isRecipe = true
        if !isSavedRecipe{
            nextViewController.food = FoodStruct(label: recipe.title, calorie: Float(recipe.calories!), image: image, carbs: Float(recipe.carbs!), fat: Float(recipe.fat!), protein: Float(recipe.protein!), wholeGram: 1.0, measureLabel: "")
        }else{
            nextViewController.food = fitTheFood(recipeTarget: foodRecipe)
        }
        
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    // Instruction buttona basıldığında oluşacak action
    @objc func showInstructionsAction() {
        // Recipe local databasede kayıtlıysa Recipe Instructionları local databaseden al
        // InstructionVC'ye git ve return ile action'ı tamamla
        if isSavedRecipe {
            if foodRecipe.instructions?.count == 0 {
                if let url = URL(string: foodRecipe.sourceURL ?? "") {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        self.presentAlert(title: "Instructions Unavailable", message: "")
                    }
                } else {
                    self.presentAlert(title: "Instructions Unavailable", message: "")
                }
            } else {
                let instructionsVC = InstructionsViewController()
                instructionsVC.foodRecipe = foodRecipe
                self.navigationController?.pushViewController(instructionsVC, animated: true)
            }
            return
        }
        // Instructionları networkingden al
        // Recipe'in Instruction'ı yok ise recipe hakkında bilgi veren websitesine git
        // Var ise InstructionVC'ye git
        if let instructions = recipe.instructions {
            if instructions.count == 0 {
                if let url = URL(string: recipe.sourceURL ?? "") {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        self.presentAlert(title: "Instructions Unavailable", message: "")
                    }
                } else {
                    self.presentAlert(title: "Instructions Unavailable", message: "")
                }
            } else {
                let instructionsVC = InstructionsViewController()
                instructionsVC.recipe = recipe
                self.navigationController?.pushViewController(instructionsVC, animated: true)
            }
        } else {
            presentAlert(title: "Instructions Unavailable", message: "")
        }
    }// ends of func showInstructionsAction
    
    // View'in üst kısmı için yaratılan CustomHeaderCell'i setup'lar
    // Cell itemları datadan çekilenlerle doldurulur
    private func createHeaderView() -> CustomHeaderCell{
        let headerView = CustomHeaderCell()
        // Recipe localDataBase'de kayıtlı değilse networkingden gelen datayı kullan
        if isSavedRecipe == false {
            if let title = recipe.title  {
                headerView.recipeTitleLabel.text = title
            }
            if let calorie = recipe.calories, let carbs = recipe.carbs, let protein = recipe.protein, let fat = recipe.fat {
                let calInt = Int(calorie.rounded())
                let carbInt = Int(carbs.rounded())
                let protInt = Int(protein.rounded())
                let fatInt = Int(fat.rounded())
                headerView.timingLabel.text = "🔥\(calInt)kcal   🥖Carbs: \(carbInt)g   🥩Protein: \(protInt)g   🧈Fat: \(fatInt)g"
            }
            if let imageURL = recipe.imageURL {
                SpoonacularClient.downloadRecipeImage(imageURL: imageURL) { (image, success) in
                    if success {
                        if let image = image {
                            self.image = image
                        } else {
                            self.image = UIImage(named: "imagePlaceholder")!
                        }
                        headerView.imageView.image = image
                    } else {
                        headerView.imageView.image = UIImage(named: "imagePlaceholder")
                        self.presentAlert(title: "Image not available", message: "")
                    }
                }
            }
            headerView.ingredientsLabel.text = "  Ingredients (\(ingredientsArray.count) items)"
        } // Recipe localDataBase'de kayıtlıysa datayı burdan al
        else {
            headerView.recipeTitleLabel.text = foodRecipe.title
            // Nutritients bilgileri localDataBase'e kayıt edilmedi networkingden al
            let calorie = foodRecipe.calories
            let carbs = foodRecipe.carbs
            let protein = foodRecipe.proteins
            let fat = foodRecipe.fats
            headerView.timingLabel.text = "  🔥\(calorie)kcal   🥖Carbs: \(carbs)g   🥩Protein: \(protein)g   🧈Fat: \(fat)g"
            headerView.imageView.image = UIImage(data: foodRecipe.image!)
            headerView.ingredientsLabel.text = "  Ingredients (\(foodRecipe.ingredients!.count) items)"
        }
        return headerView
    }
    
} // ends of DetailViewController

//MARK: - Setup TableView
extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.frame.width
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = createHeaderView()
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Local'da kayıtlı mı?
        if isSavedRecipe == false {
            return ingredientsArray.count
        } else {
            return ingredients.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.contentView.backgroundColor = ColorHardDarkGreen
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = UIFont(name: "Verdana", size: 16)
        cell.textLabel?.textColor = .lightGray
        cell.selectionStyle = .none //Cellere tıklamayı engelle
        // Local'da kayıtlı mı ?
        if isSavedRecipe == false {
            let ingredient = ingredientsArray[indexPath.row]
            cell.textLabel?.text = "\(indexPath.row + 1). \(ingredient)"
        } else {
            cell.textLabel?.text = "\(indexPath.row + 1). \(ingredients[indexPath.row].ingredient!)"
        }
        return cell
    }
}


/*
//Create SwiftUI Preview for this UIKit ViewController
struct ViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = DetailViewController
    
    func makeUIViewController(context: Context) -> DetailViewController {
        DetailViewController()
    }
    func updateUIViewController(_ uiViewController: DetailViewController, context: Context) {
    }
}

struct ViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerRepresentable()
    }
} */

