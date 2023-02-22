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
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var recipe: Recipe!
    var ingredientsArray = [String]()
    var ingredients = [Ingredient]() // Type local databasede tanımlı
    var image = UIImage()
    var isSavedRecipe = false
    var foodRecipe: FoodRecipe! // Type local databasede tanımlı
    let instructionsButton = UIButton()
    let tableView = UITableView.init(frame: CGRect.zero, style: .grouped)
    
    //MARK:- Core Data setup
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
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
        setupNavigationButtons()
    }
    
    // Localdaki datanın ingredientsleri alır
    // Ingredients tableView'i bununla updateler
    private func setupFetchRequest() {
        let fetchRequest: NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
        let predicate = NSPredicate(format: "foodRecipe == %@", foodRecipe)
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate = predicate
        if let result = try? appDelegate.persistentContainer.viewContext.fetch(fetchRequest) {
            ingredients = result
            tableView.reloadData()
        }
    }
    
    //MARK: - Setup View
    
    override func loadView() {
        super.loadView()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = ColorHardDarkGreen
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
    
    //MARK:- Setup Navigation Buttons
    private func setupNavigationButtons() {
        if isSavedRecipe == false {
            let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveAction))
            self.navigationItem.rightBarButtonItem = saveButton
        }
        // Storyboarddan'dan komple navigationItemColorları ColorGreen dene
        //self.navigationItem.rightBarButtonItem?.tintColor = ColorGreen
        //self.navigationItem.backBarButtonItem?.tintColor = ColorLightGreen
    }
    
    private func setupInstructionButton() {
        view.addSubview(instructionsButton)
        instructionsButton.translatesAutoresizingMaskIntoConstraints = false
        instructionsButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: 0).isActive = true
        instructionsButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 0).isActive = true
        instructionsButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor,constant: -4).isActive = true
        instructionsButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        instructionsButton.layer.cornerRadius = 11
        instructionsButton.layer.borderWidth = 0.3
        instructionsButton.setTitle("Instructions", for: .normal)
        instructionsButton.setTitleColor(.white, for: .normal)
        instructionsButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18.5)
        instructionsButton.backgroundColor = ColorGreen
        instructionsButton.addTarget(self, action: #selector(showInstructionsAction), for: .touchUpInside)
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
            presentAlert(title: "Recipe Saved", message: "")
        } catch {
            presentAlert(title: "Unable to save the recipe", message: "")
        }
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
                let calInt = Int(calorie)
                let carbInt = Int(carbs)
                let protInt = Int(protein)
                let fatInt = Int(fat)
                headerView.timingLabel.text = "  🔥\(calInt)kcal   🥖Carbs: \(carbInt)g   🥩Protein: \(protInt)g   🧈Fat: \(fatInt)g"
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
            if let calorie = recipe.calories, let carbs = recipe.carbs, let protein = recipe.protein, let fat = recipe.fat {
                let calInt = Int(calorie)
                let carbInt = Int(carbs)
                let protInt = Int(protein)
                let fatInt = Int(fat)
                headerView.timingLabel.text = "  🔥\(calInt)kcal   🥖Carbs: \(carbInt)g   🥩Protein: \(protInt)g   🧈Fat: \(fatInt)g" }
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

