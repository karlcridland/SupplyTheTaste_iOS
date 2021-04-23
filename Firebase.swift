//
//  Firebase.swift
//  resupply the taste
//
//  Created by Karl Cridland on 03/03/2021.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage
import CoreLocation

class Firebase {
    
    private var images = [String:UIImage]()
    
    public static let shared = Firebase()
    
    private let picRef = Storage.storage().reference(forURL: "gs://supplythetaste.appspot.com/")
    private let ref: DatabaseReference
    private let storageRef = Storage.storage().reference()
    
    private init(){
        ref = Database.database().reference()
    }
    
    func add_token(_ token: String){
        ref.child("users/notificationTokens/sOJL3aQvxTXzSQBQLB2c5cw1p923/\(token)/").setValue(true)
    }
    
    func update_order_count(){
        var i = 0
        for order in Settings.shared.orders{
            if (!order.dispatched){
                i += 1
            }
        }
        ref.child("order_count").setValue(i)
        UIApplication.shared.applicationIconBadgeNumber = i
    }
    
    func get_tags(){
        ref.child("meal_tags").observeSingleEvent(of: .value) { (snapshot) in
            (snapshot.children.allObjects as! [DataSnapshot]).forEach { (tag) in
                if let value = tag.value as? String{
                    Settings.shared.tags.append(value)
                }
            }
            Settings.shared.tags.sort()
        }
    }
    
    func save_meals(){
        var type_count = [String:Int]()
        
        let location = "meals"
        ref.child(location).setValue(nil)
        Settings.shared.meals.forEach { (meal) in
            if (!type_count.keys.contains(meal.type!)){
                type_count[meal.type!] = 0
            }
            else{
                type_count[meal.type!]! += 1
            }
            ref.child("\(location)/\(meal.type!)/\(type_count[meal.type!]!)/name").setValue(meal.title)
            ref.child("\(location)/\(meal.type!)/\(type_count[meal.type!]!)/desc").setValue(meal.subtitle)
            ref.child("\(location)/\(meal.type!)/\(type_count[meal.type!]!)/allergens").setValue(meal.allergens)
            ref.child("\(location)/\(meal.type!)/\(type_count[meal.type!]!)/head_count").setValue(meal.serves)
            ref.child("\(location)/\(meal.type!)/\(type_count[meal.type!]!)/instructions").setValue(meal.instructions)
            ref.child("\(location)/\(meal.type!)/\(type_count[meal.type!]!)/vegetarian").setValue(meal.vegetarian)
            ref.child("\(location)/\(meal.type!)/\(type_count[meal.type!]!)/spiciness").setValue(meal.spiciness)
            ref.child("\(location)/\(meal.type!)/\(type_count[meal.type!]!)/price").setValue(meal.price)
            ref.child("\(location)/\(meal.type!)/\(type_count[meal.type!]!)/vegan").setValue(meal.vegan)
            ref.child("\(location)/\(meal.type!)/\(type_count[meal.type!]!)/in_stock").setValue(meal.in_stock)
            
            var i = 0
            for tag in meal.tags{
                ref.child("\(location)/\(meal.type!)/\(type_count[meal.type!]!)/meal_tags/\(i)").setValue(tag)
                i += 1
            }
        }
    }
    
    func get_orders() {
        ref.child("orders/status").observeSingleEvent(of: .value) { (snapshot) in
            for user in snapshot.children.allObjects as! [DataSnapshot]{
                if (user.key != "szQHoW15FIfV3qf6VPFwXfCu3163"){
                    for order in user.children.allObjects as! [DataSnapshot]{
                        if let prepared = order.childSnapshot(forPath: "prepared").value as? Bool{
                            if let dispatched = order.childSnapshot(forPath: "dispatched").value as? Bool{
                                if let previous_order = Settings.shared.orders.first(where: {$0.uid == user.key && $0.id == order.key}){
                                    previous_order.dispatched = dispatched
                                    previous_order.prepared = prepared
                                }
                                else{
                                    let new_order = UserOrder(uid: user.key, id: order.key)
                                    new_order.dispatched = dispatched
                                    new_order.prepared = prepared
                                    Settings.shared.orders.append(new_order)
                                }
                            }
                        }
                    }
                }
            }
            Settings.shared.update_orders()
            self.update_order_count()
            if let chart = Settings.shared.stats?.chart{
                chart.sort_data()
            }
        }
    }
    
    func get_order_details(_ order: UserOrder){
        if (order.uid == "test"){
            
            order.ready = true
            return
        }
        ref.child("orders/user/\(order.uid)/\(order.id)").observeSingleEvent(of: .value) { (snapshot) in
            var address = ""
            for field in ["line1","line2","town","county","country","postcode"]{
                if let value = snapshot.childSnapshot(forPath: "address/\(field)").value as? String{
                    if (value.count > 0){
                        address += value + "\n"
                    }
                }
            }
            address.removeLast()
            order.address = address
            if let value = snapshot.childSnapshot(forPath: "date").value as? String{
                order.date = value
            }
            if let value = snapshot.childSnapshot(forPath: "name").value as? String{
                order.name = value
            }
            if let value = snapshot.childSnapshot(forPath: "note").value as? String{
                order.message = value
            }
            for item in snapshot.childSnapshot(forPath: "basket").children.allObjects as! [DataSnapshot]{
                if let name = item.childSnapshot(forPath: "name").value as? String{
                    if let price = item.childSnapshot(forPath: "price").value as? Int{
                        if let quantity = item.childSnapshot(forPath: "quantity").value as? Int{
                            let new_item = MenuItem(title: name, price: price, quantity: quantity)
                            order.basket.append(new_item)
                        }
                    }
                }
            }
            if let stats = Settings.shared.stats{
                stats.chart.sort_data()
                stats.update()
            }
            order.ready = true
            Settings.shared.allow_access()
        }
    }
    
    func get_menus(){
        ref.child("meals").observeSingleEvent(of: .value) { (snapshot_) in
            for type in ["starters","main","dessert","side","misc"]{
                let snapshot = snapshot_.childSnapshot(forPath: type)
                for meal in snapshot.children.allObjects as! [DataSnapshot]{
                    if let title = meal.childSnapshot(forPath: "name").value as? String{
                        if let subtitle = meal.childSnapshot(forPath: "desc").value as? String{
                            if let allergens = meal.childSnapshot(forPath: "allergens").value as? String{
                                let new_menu = FoodMenu(title: title, subtitle: subtitle, type: type, allergens: allergens)
                                
                                if let price = meal.childSnapshot(forPath: "price").value as? Int{
                                    new_menu.price = price
                                }
                                
                                if let instructions = meal.childSnapshot(forPath: "instructions").value as? Bool{
                                    new_menu.instructions = instructions
                                }
                                
                                if let vegetarian = meal.childSnapshot(forPath: "vegetarian").value as? Bool{
                                    new_menu.vegetarian = vegetarian
                                }
                                
                                if let vegan = meal.childSnapshot(forPath: "vegan").value as? Bool{
                                    new_menu.vegan = vegan
                                }
                                
                                self.ref.child("meals/\(type)/\(meal.key)/meal_tags").observeSingleEvent(of: .value) { (tags) in
                                    for child in tags.children.allObjects as! [DataSnapshot]{
                                        if let value = child.value as? String{
                                            new_menu.tags.append(value)
                                        }
                                    }
                                }
                                
                                self.ref.child("meals/\(type)/\(meal.key)/in_stock").observeSingleEvent(of: .value) { (stock) in
                                    if let value = stock.value as? Bool{
                                        new_menu.in_stock = value
                                    }
                                }
                                
                                if let head_count = meal.childSnapshot(forPath: "head_count").value as? String{
                                    new_menu.serves = head_count
                                }
                                
                                Settings.shared.meals.append(new_menu)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func get_special(_ page: PageSpecial){
        func get_data(_ input: String, _ update: String){
            ref.child("specials/\(input)").observeSingleEvent(of: .value) { (snapshot) in
                if let value = snapshot.value as? String{
                    if let field = page.fields[update]{
                        field.text = value
                    }
                }
            }
        }
        ["starter","mains","dessert"].forEach { (field) in
            ["1","2"].forEach { (variant) in
                get_data("\(field)/\(page.month.lowercased())/\(variant)", "\(field) \(variant)")
            }
        }
        get_data("extra/\(page.month.lowercased())", "extra")
        get_data("name/\(page.month.lowercased())", "name")
    }
    
    func save(_ page: PageSpecial){
        ref.child("specials/name/\(page.month.lowercased())").setValue(page.fields["name"]!.text)
        ref.child("specials/starter/\(page.month.lowercased())/1").setValue(page.fields["starter 1"]!.text)
        ref.child("specials/starter/\(page.month.lowercased())/2").setValue(page.fields["starter 2"]!.text)
        ref.child("specials/mains/\(page.month.lowercased())/1").setValue(page.fields["mains 1"]!.text)
        ref.child("specials/mains/\(page.month.lowercased())/2").setValue(page.fields["mains 2"]!.text)
        ref.child("specials/dessert/\(page.month.lowercased())/1").setValue(page.fields["dessert 1"]!.text)
        ref.child("specials/dessert/\(page.month.lowercased())/2").setValue(page.fields["dessert 2"]!.text)
        ref.child("specials/extra/\(page.month.lowercased())").setValue(page.fields["extra"]!.text)
    }
    
    func update(_ order: UserOrder){
        ref.child("orders/status/\(order.uid)/\(order.id)/dispatched").setValue(order.dispatched)
        ref.child("orders/status/\(order.uid)/\(order.id)/prepared").setValue(order.prepared)
        ref.child("orders/timestamp/\(order.uid)/\(order.id)/dispatched").setValue(timestamp())
        ref.child("orders/timestamp/\(order.uid)/\(order.id)/prepared").setValue(timestamp())
    }
    
    func get_customers(_ page: PageCustomers){
        var customers = [String:[String:Any]]()
        
        func finished(){
            var temp = [String: Bool]()
            customers.forEach { (key, value) in
                if let first = value["first"] as? String{
                    if let last = value["last"] as? String{
                        if let instructions = value["instructions"] as? Bool{
                            temp["\(first) \(last)"] = instructions
                        }
                        else{
                            customers[key]!["instructions"] = true
                        }
                    }
                }
            }
            page.customers = temp
            page.update()
        }
        func add_to(path: String, key: String){
            ref.child("users/\(path)").observeSingleEvent(of: .value) { (snapshot) in
                (snapshot.children.allObjects as! [DataSnapshot]).forEach { (user) in
                    if (user.key != "szQHoW15FIfV3qf6VPFwXfCu3163"){
                        if let value = user.value{
                            if (customers.keys.contains(user.key)){
                                customers[user.key]![key] = value
                            }
                            else{
                                customers[user.key] = [key:value]
                            }
                        }
                    }
                }
                finished()
            }
        }
        add_to(path: "first name", key: "first")
        add_to(path: "last name", key: "last")
        add_to(path: "settings/paper", key: "instructions")
    }
    
}


func timestamp() -> String {
    return Date().toString()
}

extension String{
    
    func setw(_ character: Character, _ width: Int) -> String{
        var new = self
        while new.count < width{
            new = String(character)+new
        }
        return new
    }
    
}


extension Date{
    
    func toString() -> String{
        
        let second = String(get(.second)).setw("0", 2)
        let minute = String(get(.minute)).setw("0", 2)
        let hour = String(get(.hour)).setw("0", 2)
        let day = String(get(.day)).setw("0", 2)
        let month = String(get(.month)).setw("0", 2)
        let year = String(get(.year))
        
        return "\(year):\(month):\(day):\(hour):\(minute):\(second)"
    }
    
    func get(_ type: dateType) -> Int{
        
        // Returns a value from the current time or date.
        
        let formatter = DateFormatter()
        
        switch type {
        
            case .second:
                formatter.dateFormat = "ss"
                break
                
            case .minute:
                formatter.dateFormat = "mm"
                break
                
            case .hour:
                formatter.dateFormat = "HH"
                break
                
            case .day:
                formatter.dateFormat = "dd"
                break
                
            case .month:
                formatter.dateFormat = "MM"
                break
                
            case .year:
                formatter.dateFormat = "yyyy"
                break
                
        }
        
        return Int(formatter.string(from: self))!
    }
}

enum dateType{
    case day
    case month
    case year
    case second
    case minute
    case hour
}
