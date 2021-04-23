//
//  UserOrder.swift
//  resupply the taste
//
//  Created by Karl Cridland on 03/03/2021.
//

import Foundation

class UserOrder{
    
    let uid: String
    let id: String
    var dispatched = false
    var prepared = false
    
    var name: String?
    var address: String?
    var basket = [MenuItem]()
    var date: String?
    var message: String?
    
    var ready = false
    
    init(uid: String, id: String) {
        self.uid = uid
        self.id = id
        Firebase.shared.get_order_details(self)
    }
    
    func update_order_status(){
        Firebase.shared.update(self)
    }
    
    func total() -> Int{
        var t = 0
        basket.forEach { (item) in
            t += item.price * item.quantity
        }
        return t
    }
    
}

class MenuItem {
    
    let title: String
    let price: Int
    let quantity: Int
    
    init(title: String, price: Int, quantity: Int) {
        self.title = title
        self.price = price
        self.quantity = quantity
    }
}
