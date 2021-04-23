//
//  Settings.swift
//  resupply the taste
//
//  Created by Karl Cridland on 21/02/2021.
//

import Foundation
import UIKit

class Settings {
    
    var home: ViewController?
    var upper_bound: CGFloat?
    var lower_bound: CGFloat?
    var keyboard_height = CGFloat(0.0)
    
    var orders = [UserOrder]()
    var meals = [FoodMenu]()
    var tags = [String]()
    
    var stats: Statistics?
    
    var screen: UIView?
    
    public static let shared = Settings()
    
    private init(){}
    
    func update_orders(){
        orders = orders.sorted(by: {$0.id < $1.id})
    }
    
    func allow_access(){
        if (orders_ready()){
            if let screen = self.screen{
                UIView.animate(withDuration: 0.3) {
                    screen.alpha = 0
                } completion: { (_) in
                    screen.removeFromSuperview()
                }
            }
        }
    }
    
    private func orders_ready() -> Bool{
        var r = true
        var count = 0
        for order in orders{
            if (!order.ready){
                r = false
            }
            else{
                count += 1
            }
        }
        if (orders.count > 0){
            if let home = home{
                home.update_screen(ready: count, total: orders.count)
            }
        }
        return r
    }
}

