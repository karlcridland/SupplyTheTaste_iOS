//
//  PageSpecials.swift
//  resupply the taste
//
//  Created by Karl Cridland on 04/03/2021.
//

import Foundation
import UIKit
let months = ["January","February","March","April","May","June","July","August","September","October","November","December"]

class PageSpecials: Page {
    init(){
        super.init(title: "Specials")
        
        var i = 0
        months.forEach { (month) in
            let x = ((i%2)*Int(UIScreen.main.bounds.width)/2)
            let y = ((i/2)*60)
            let button = MonthButton(frame: CGRect(x: x, y: y+30, width: Int(UIScreen.main.bounds.width)/2, height: 60))
            button.setTitle(month,for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .highlighted)
            button.titleLabel?.font = .systemFont(ofSize: 18, weight: UIFont.Weight(0.4))
            button.month = month
            view.addSubview(button)
            button.addTarget(self, action: #selector(open_month), for: .touchUpInside)
            i += 1
        }
    }
    
    @objc func open_month(sender: MonthButton){
        if let month = sender.month{
            let _ = PageSpecial(month)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MonthButton:UIButton{
    var month: String?
}
