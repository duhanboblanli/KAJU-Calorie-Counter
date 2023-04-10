//
//  TabBarController.swift
//  KAJU
//
//  Created by Duhan Boblanlı on 11.02.2023.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defineLabels()
        self.navigationController?.isNavigationBarHidden = true
    }
    func defineLabels(){
        tabBar.items![0].title = tabBar.items![0].title?.localized()
        tabBar.items![1].title = tabBar.items![1].title?.localized()
        tabBar.items![2].title = tabBar.items![2].title?.localized()
        tabBar.items![3].title = tabBar.items![3].title?.localized()
    }
}
