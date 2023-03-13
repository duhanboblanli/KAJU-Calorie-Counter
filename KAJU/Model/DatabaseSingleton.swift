//
//  DatabaseSingleton.swift
//  KAJU
//
//  Created by kadir on 8.03.2023.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage

class DatabaseSingleton {
    static let db = Firestore.firestore()
    static let storage = Storage.storage()
    init(){}
}
