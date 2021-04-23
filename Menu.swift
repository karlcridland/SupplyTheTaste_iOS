//
//  Menu.swift
//  resupply the taste
//
//  Created by Karl Cridland on 21/02/2021.
//

import Foundation
import UIKit

class Menu: UIView {
    
    public static let shared = Menu()
    private var extended = false
    
    private init(){
        super .init(frame: CGRect(x: -UIScreen.main.bounds.width, y: 70+Settings.shared.upper_bound!, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-(70+Settings.shared.upper_bound!)))
        self.backgroundColor = .white
        var i = 0
        var buttons = [String:UIButton]()
        for title in ["orders","menu","specials","customers"]{
            let button = UIButton(frame: CGRect(x: 0, y: CGFloat(i)*50+10, width: self.frame.width, height: 50))
            buttons[title] = button
            button.setTitle(title, for: .normal)
            button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            button.setTitleColor(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1), for: .highlighted)
            button.contentHorizontalAlignment = .right
            button.titleLabel!.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight(0.4))
            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 30.0)
            self.addSubview(button)
            i += 1
        }
        buttons["orders"]!.addTarget(self, action: #selector(open_orders), for: .touchUpInside)
        buttons["menu"]!.addTarget(self, action: #selector(open_menu), for: .touchUpInside)
        buttons["specials"]!.addTarget(self, action: #selector(open_specials), for: .touchUpInside)
        buttons["customers"]!.addTarget(self, action: #selector(open_customers), for: .touchUpInside)
    }
    
    @objc func open_orders(){
        if (Settings.shared.orders.count > 0){
            let _ = PageOrders()
        }
    }
    
    @objc func open_menu(){
        if (Settings.shared.meals.count > 0){
            let _ = PageMenu()
        }
    }
    
    @objc func open_specials(){
        let _ = PageSpecials()
    }
    
    @objc func open_customers(){
        let _ = PageCustomers()
    }
    
    func activate(){
        extended = !extended
        var x = -UIScreen.main.bounds.width
        if (extended){
            x = 0
        }
        UIView.animate(withDuration: 0.3, animations:{
            self.frame = CGRect(x: x, y: self.frame.minY, width: self.frame.width, height: self.frame.height)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
