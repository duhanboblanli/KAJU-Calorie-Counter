//
//  InstructionsViewController.swift
//  KAJU
//
//  Created by Duhan Boblanlı on 22.02.2023.
//

import UIKit
import CoreData

class InstructionsViewController: UIViewController {
    
    // General variables
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let tableView = UITableView()
    var recipe: Recipe!
    var foodRecipe: FoodRecipe!
    var isSavedRecipe = false
    var instructions = [Instruction]()
    var instructionsArray = [String]()
    let instructionsButton = UIButton()
    
    // Setup variables
    let recipeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 27.0)
        label.textAlignment = .center
        label.backgroundColor = UIColor( red: 26/255, green: 47/255, blue: 75/255, alpha: 1)
        label.textColor = .white
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    //MARK: - Core Data setup
    override func viewDidLoad() {
        if foodRecipe != nil {
            isSavedRecipe = true
            setupFetchRequest()
            return
        }
        if let instructions = recipe.instructions {
            self.instructionsArray = instructions
        } else {
            presentAlert(title: "Instructions Unavailable", message: "")
        }
    }
    
    private func setupFetchRequest() {
        let fetchRequest: NSFetchRequest<Instruction> = Instruction.fetchRequest()
        let predicate = NSPredicate(format: "foodRecipe == %@", foodRecipe)
        let sortDescriptor = NSSortDescriptor(key: "stepNumber", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = predicate
        if let result = try? appDelegate.persistentContainer.viewContext.fetch(fetchRequest) {
            instructions = result
            tableView.reloadData()
        }
    }
    
    //MARK: - Setup View
    override func loadView() {
        super.loadView()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = ThemeColors.colorHardDarkGreen.associatedColor
        setupInstructionButton()
        setupTableView()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        // Default cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        // Constraints
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: instructionsButton.topAnchor, constant: 0).isActive = true
        tableView.backgroundColor = ThemeColors.colorHardDarkGreen.associatedColor
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        tableView.separatorColor = ThemeColors.colorLightGreen.associatedColor
    }
    
    private func setupInstructionButton() {
        view.addSubview(instructionsButton)
        instructionsButton.translatesAutoresizingMaskIntoConstraints = false
        instructionsButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: 0).isActive = true
        instructionsButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 0).isActive = true
        instructionsButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor,constant: -4).isActive = true
        instructionsButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        instructionsButton.layer.cornerRadius = 11
        instructionsButton.layer.borderWidth = 0.3
        instructionsButton.setTitle("Visit Website for More", for: .normal)
        instructionsButton.setTitleColor(.white, for: .normal)
        instructionsButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18.5)
        instructionsButton.backgroundColor = ThemeColors.colorGreen.associatedColor
        instructionsButton.addTarget(self, action: #selector(showInstructionsAction), for: .touchUpInside)
    }
    
    // Instruction buttona basıldığında oluşacak action
    @objc func showInstructionsAction() {
        if isSavedRecipe {
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
            if let url = URL(string: recipe.sourceURL ?? "") {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    self.presentAlert(title: "Instructions Unavailable", message: "")
                }
            } else {
                self.presentAlert(title: "Instructions Unavailable", message: "")
            }
        }
    }
   
}

//MARK: - Setup TableView
extension InstructionsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSavedRecipe {
            return instructions.count
        } else {
            return instructionsArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if isSavedRecipe == false {
            let instruction = instructionsArray[indexPath.row]
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.font = UIFont(name: "Verdana", size: 16)
            cell.textLabel?.text = "\(indexPath.row + 1). \(instruction)"
        } else {
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.font = UIFont(name: "Verdana", size: 16)
            cell.textLabel?.text = "\(indexPath.row + 1). \(instructions[indexPath.row].instruction!)"
        }
        cell.backgroundColor = ThemeColors.colorHardDarkGreen.associatedColor
        cell.textLabel?.textColor = .lightGray
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = InstructionsHeaderCell()
        if isSavedRecipe == false {
            headerView.ingredientsLabel.text = "☑️Instructions (\(instructionsArray.count) items)" }
        else {
            headerView.ingredientsLabel.text = "☑️Instructions (\(foodRecipe.instructions!.count) items)"
        }
        return headerView
    }
}

