//
//  PageMenus.swift
//  resupply the taste
//
//  Created by Karl Cridland on 04/03/2021.
//

import Foundation
import UIKit

class PageMenu: Page {
    
    let search = UITextField(frame: CGRect(x: 20, y: 00, width: UIScreen.main.bounds.width-40, height: 50))
    
    init() {
        super .init(title: "Menu")
        self.update()
        self.view.frame = CGRect(x: 0, y: 50, width: super.frame.width, height: super.frame.height-50)
        self.addSubview(self.search)
        self.search.font = .systemFont(ofSize: 18, weight: UIFont.Weight(0.4))
        self.search.addTarget(self, action: #selector(update), for: .allEditingEvents)
        self.search.placeholder = "search"
        self.search.returnKeyType = .done
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    let max_height = UIScreen.main.bounds.height-Settings.shared.lower_bound!-Header.shared.frame.height
    
    @objc func keyboardWillShow(_ notification: Notification){
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            Settings.shared.keyboard_height = keyboardRectangle.height
            
            UIView.animate(withDuration: 0.2, animations: {
                self.view.frame = CGRect(x: 0, y: 50, width: UIScreen.main.bounds.width, height: self.frame.height-50-keyboardRectangle.height)
            })
        }
        
    }
    
    @objc func keyboardWillHide(_ notification: Notification){
        
        UIView.animate(withDuration: 0.2, animations: {
            self.view.frame = CGRect(x: 0, y: 50, width: UIScreen.main.bounds.width, height: self.frame.height-50)
        })
        
    }
    
    @objc func update() {
        
        var i = 0
        let height = 60
        self.view.removeAll()
        func add_button(title: String) -> MenuButton{
            let button = MenuButton(frame: CGRect(x: 20, y: 10+(i*(height+10)), width: Int(self.view.frame.width)-40, height: height))
            button.setTitle(title, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .highlighted)
            button.titleLabel?.font = .systemFont(ofSize: 18, weight: UIFont.Weight(0.4))
            button.titleLabel?.numberOfLines = 0
            button.contentHorizontalAlignment = .left
            button.addTarget(self, action: #selector(open_meal), for: .touchUpInside)
            return button
        }
        
        
        let button = add_button(title: "New Meal 🍽")
        self.view.addSubview(button)
        i += 1
        
        let search_result = search.text!
        
        for meal in Settings.shared.meals{
            if (search_result.count == 0 || meal.title.contains(search_result)){
                let button = add_button(title: meal.title)
                self.view.addSubview(button)
                button.meal = meal
                i += 1
            }
        }
        
        self.view.contentSize = CGSize(width: self.view.frame.width, height: self.view.maxY())
    }
    
    @objc func open_meal(sender: MenuButton){
        if let meal = sender.meal{
            let _ = PageEditMenu(menu: meal)
        }
        else{
            let _ = PageEditNewMenu()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MenuButton: UIButton {
    var meal: FoodMenu?
}

class FoodMenu {
    
    var title: String
    var subtitle: String
    var allergens: String
    var type: String?
    
    var vegetarian = false
    var vegan = false
    var instructions = false
    var serves = "two"
    var price = 1100
    var spiciness = 0
    var in_stock = true
    
    var tags = [String]()
    
    var pic: UIImageView?
    
    init(title: String, subtitle: String, type: String?, allergens: String) {
        self.title = title
        self.subtitle = subtitle
        self.allergens = allergens
        self.type = type
    }
}
