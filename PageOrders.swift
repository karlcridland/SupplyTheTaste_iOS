//
//  PageOrders.swift
//  resupply the taste
//
//  Created by Karl Cridland on 03/03/2021.
//

import Foundation
import UIKit

class PageOrders: Page {
    
//    let archive = UIButton(frame: CGRect(x: UIScreen.main.bounds.width-120, y: 10, width: 100, height: 30))
    let archive = UISegmentedControl(items: ["current", "history"])
    var show_archive = false
    
    init() {
        super.init(title: "Orders")
        self.view.frame = CGRect(x: 0, y: 50, width: super.frame.width, height: super.frame.height-50)
        
        self.set_up_archive()
        self.display()
    }
    
    func set_up_archive() {
        self.archive.frame = CGRect(x: 5, y: 5, width: self.frame.width-10, height: 45)
        self.archive.addTarget(self, action: #selector(toggle_archive), for: .valueChanged)
        let font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(0.3))
        self.archive.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        self.archive.selectedSegmentIndex = 0
        self.archive.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.addSubview(archive)
    }
    
    @objc func toggle_archive(sender: UISegmentedControl){
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        self.show_archive = sender.selectedSegmentIndex == 1
        
        if (self.show_archive){
            Settings.shared.orders.sort(by: {$0.id > $1.id})
        }
        else{
            Settings.shared.orders.sort(by: {$0.id < $1.id})
        }
        
        self.display()
    }
    
    func display() {
        self.view.removeAll()
        var i = 0
        for order in Settings.shared.orders{
            if ((self.show_archive && order.dispatched == true) || (!self.show_archive && !order.dispatched)){
                
                let background = UIView(frame: CGRect(x: 20, y: 20+(100*i), width: Int(self.view.frame.width)-40, height: 80))
                background.layer.cornerRadius = 8
                background.layer.borderWidth = 2
                background.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).withAlphaComponent(0.6).cgColor
                background.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                background.layer.shadowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                background.layer.shadowOpacity = 0.2
                background.layer.shadowOffset = .init(width: 0, height: 10)
                background.layer.shadowRadius = 15
                
                let button = OrderButton(frame: CGRect(x: 35, y: 10+(100*i), width: Int(self.view.frame.width)-20, height: 100))
                button.titleLabel?.font = .systemFont(ofSize: 18, weight: UIFont.Weight(0.3))
                button.contentHorizontalAlignment = .left
                button.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                button.imageView?.contentMode = .scaleAspectFit
                button.setTitle("\(order.name!)\n\(order.date!.getDate())", for: .normal)
                button.setTitleColor(.black, for: .normal)
                button.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .highlighted)
                button.titleLabel?.numberOfLines = 2
                button.setImage(UIImage(named: "back"), for: .normal)
                button.setImage(UIImage(named: "back_blue"), for: .highlighted)
                
                let imageWidth = button.imageView!.frame.width
                let buttonWidth = button.frame.width
                button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: 0, right: imageWidth)
                button.imageEdgeInsets = UIEdgeInsets(top: 0, left: buttonWidth-imageWidth, bottom: 0, right: -(buttonWidth-imageWidth))
                view.addSubview([background,button])
                i += 1
                
                button.addTarget(self, action: #selector(open_order), for: .touchUpInside)
                button.order = order
            }
        }
        self.view.contentSize = CGSize(width: self.view.frame.width, height: self.view.maxY())
    }
    
    @objc func open_order(sender: OrderButton){
        if let order = sender.order{
            let _ = PageOrder(order: order)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class OrderButton: UIButton {
    var order: UserOrder?
}


extension String{
    func getDate() -> String{
        let year = self.split(separator: ":")[0]
        let month = self.split(separator: ":")[1]
        let day = self.split(separator: ":")[2]
        if let d = Int(day){
            if let m = Int(month){
                if let y = Int(year){
                    return "\(d) \(months[m]) \(y)"
                }
            }
        }
        return "error - no date found"
    }
}
