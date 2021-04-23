//
//  PageOrder.swift
//  resupply the taste
//
//  Created by Karl Cridland on 04/03/2021.
//

import Foundation
import UIKit

class PageOrder: Page {
    
    let order: UserOrder
    init(order: UserOrder) {
        self.order = order
        super .init(title: order.name!)
        self.view.frame = CGRect(x: 0, y: 50, width: super.frame.width, height: super.frame.height-50)
        
        let status = UISegmentedControl(items: ["untouched", "prepared", "dispatched"])
        status.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        status.layer.borderWidth = 2
        addSubview(status)
        status.frame = CGRect(x: 5, y: 5, width: self.view.frame.width-10, height: 45)
        let font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(0.3))
        status.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        status.addTarget(self, action: #selector(update_order_status), for: .valueChanged)
        
        if (order.dispatched){
            status.selectedSegmentIndex = 2
        }
        else if (order.prepared){
            status.selectedSegmentIndex = 1
        }
        else{
            status.selectedSegmentIndex = 0
        }
        
        let what = UILabel(frame: CGRect(x: 20, y: 10, width: self.frame.width-40, height: 50))
        what.text = "What do you need to make?"
        what.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight(0.5))
        self.view.addSubview(what)
        
        var i = 0
        order.basket.forEach { (item) in
            let t = UILabel(frame: CGRect(x: 20, y: (what.frame.maxY + (CGFloat(i)*50)), width: self.frame.width-90, height: 50))
            t.numberOfLines = 0
            let q = UILabel(frame: CGRect(x: t.frame.maxX+20, y: what.frame.maxY + (CGFloat(i)*50), width: 50, height: 50))
            t.font = font
            q.font = font
            view.addSubview([t,q])
            t.text = item.title
            q.text = String(item.quantity)
            i += 1
        }
        
        let wher = UILabel(frame: CGRect(x: 20, y: what.frame.maxY + (CGFloat(i)*50), width: self.frame.width-40, height: 50))
        wher.text = "Where does it need to go?"
        wher.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight(0.5))
        self.view.addSubview(wher)
        
        let address = UILabel(frame: CGRect(x: 20, y: wher.frame.maxY, width: self.frame.width-40, height: 150))
        address.text = order.address!
        address.numberOfLines = 0
        address.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight(0.3))
        self.view.addSubview(address)
        
        let anyt = UILabel(frame: CGRect(x: 20, y: address.frame.maxY, width: self.frame.width-40, height: 50))
        anyt.text = "Anything else?"
        anyt.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight(0.5))
        self.view.addSubview(anyt)
        
        let message = UITextView(frame: CGRect(x: 15, y: anyt.frame.maxY, width: self.frame.width-30, height: 150))
        message.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight(0.3))
        self.view.addSubview(message)
        message.isUserInteractionEnabled = false
        message.text = "No comment left by customer, nice and easy."
        if let m = order.message{
            if m.count > 0{
                message.text = m
            }
        }
        
        self.view.contentSize = CGSize(width: self.view.frame.width, height: self.view.maxY())
        
    }
    
    @objc func update_order_status(sender: UISegmentedControl){
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        switch sender.selectedSegmentIndex {
        case 0:
            order.dispatched = false
            order.prepared = false
            break
        case 1:
            order.dispatched = false
            order.prepared = true
            break
        case 2:
            order.dispatched = true
            order.prepared = true
            break
        default:
            break
        }
        order.update_order_status()
        Firebase.shared.update_order_count()
        Pages.shared.update_orders_page()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
