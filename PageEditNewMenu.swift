//
//  PageEditNewMenu.swift
//  resupply the taste
//
//  Created by Karl Cridland on 04/03/2021.
//

import Foundation
import UIKit

class PageEditNewMenu: PageEditMenu {
    
    let new_menu = FoodMenu(title: "", subtitle: "", type: nil, allergens: "")
    
    init(){
        super .init(menu: new_menu)
        self.title = "New Menu"
        Pages.shared.update()
    }
    
    override func save_all() {
        if (can_save()){
            Settings.shared.meals.append(new_menu)
            super.save_all()
            Pages.shared.remove()
            if let page = Pages.shared.last() as? PageMenu{
                page.update()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
