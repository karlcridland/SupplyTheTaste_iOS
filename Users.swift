//
//  Users.swift
//  resupply the taste
//
//  Created by Karl Cridland on 03/03/2021.
//

import Foundation

class User {
    
    let uid: String
    var name: String?
    
    init(uid: String) {
        self.uid = uid
    }
}

class Users {
    
    static var all = [String: User]()
    
}

