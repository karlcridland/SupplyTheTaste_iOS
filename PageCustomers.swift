//
//  PageCustomers.swift
//  resupply the taste
//
//  Created by Karl Cridland on 06/03/2021.
//

import Foundation
import UIKit

class PageCustomers: Page {
    
    var customers = [String: Bool]()
    
    init(){
        super .init(title: "Customers")
        Firebase.shared.get_customers(self)
    }
    
    func update(){
        self.view.removeAll()
        
        let title = UILabel(frame: CGRect(x: 20, y: 10, width: self.view.frame.width-40, height: 40))
        title.text = "Send paper instructions to:"
        title.font = .systemFont(ofSize: 20, weight: UIFont.Weight(rawValue: 0.4))
        self.view.addSubview(title)
        
        var i = 0
        self.customers.sorted(by: {$0.key < $1.key}).forEach { (key,value) in
            let name = UILabel(frame: CGRect(x: 20, y: 60+(CGFloat(i)*50), width: UIScreen.main.bounds.width-140, height: 50))
            name.numberOfLines = 0
            name.text = key
            name.font = .systemFont(ofSize: 18, weight: UIFont.Weight(rawValue: 0.3))
            
            let result = UILabel(frame: CGRect(x: name.frame.maxX, y: name.frame.minY, width: 100, height: name.frame.height))
            result.font = .systemFont(ofSize: 18, weight: UIFont.Weight(rawValue: 0.5))
            result.numberOfLines = 1
            result.textAlignment = .center
            if (value){
                result.text = "yes"
                result.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            }
            else{
                result.text = "no"
                result.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            }
            
            self.view.addSubview([name,result])
            self.view.contentSize = CGSize(width: self.view.frame.width, height: name.frame.maxY)
            
            i += 1
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
