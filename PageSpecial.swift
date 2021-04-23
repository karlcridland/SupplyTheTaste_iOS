//
//  PageSpecial.swift
//  resupply the taste
//
//  Created by Karl Cridland on 04/03/2021.
//

import Foundation
import UIKit

class PageSpecial: Page {
    
    let month: String
    
    var fields = [String:UITextField]()
    
    init(_ month: String) {
        self.month = month
        super .init(title: "\(month) Special")
        
        Firebase.shared.get_special(self)
        
        let name = InputField(title: "name", frame: CGRect(x: 10, y: 10, width: view.frame.width-20, height: 50))
        fields["name"] = name.input
        let reg_starter = InputField(title: "starter", frame: CGRect(x: 10, y: name.frame.maxY+10, width: view.frame.width-20, height: 50))
        fields["starter 1"] = reg_starter.input
        let reg_main = InputField(title: "main", frame: CGRect(x: 10, y: reg_starter.frame.maxY+10, width: view.frame.width-20, height: 50))
        fields["mains 1"] = reg_main.input
        let reg_dessert = InputField(title: "dessert", frame: CGRect(x: 10, y: reg_main.frame.maxY+10, width: view.frame.width-20, height: 50))
        fields["dessert 1"] = reg_dessert.input
        let veg_starter = InputField(title: "starter - veg", frame: CGRect(x: 10, y: reg_dessert.frame.maxY+10, width: view.frame.width-20, height: 50))
        fields["starter 2"] = veg_starter.input
        let veg_main = InputField(title: "main - veg", frame: CGRect(x: 10, y: veg_starter.frame.maxY+10, width: view.frame.width-20, height: 50))
        fields["mains 2"] = veg_main.input
        let veg_dessert = InputField(title: "dessert - veg", frame: CGRect(x: 10, y: veg_main.frame.maxY+10, width: view.frame.width-20, height: 50))
        fields["dessert 2"] = veg_dessert.input
        let extra = InputField(title: "extra", frame: CGRect(x: 10, y: veg_dessert.frame.maxY+10, width: view.frame.width-20, height: 50))
        fields["extra"] = extra.input
        
        let save = UIButton(frame: CGRect(x: 3*UIScreen.main.bounds.width/6-75, y: extra.frame.maxY+20, width: 150, height: 40))
        save.titleLabel?.font = .systemFont(ofSize: 18, weight: UIFont.Weight(0.4))
        save.setTitle("save", for: .normal)
        save.setTitleColor(.white, for: .normal)
        save.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        save.layer.cornerRadius = 8
        save.addTarget(self, action: #selector(save_clicked), for: .touchUpInside)
        
        view.addSubview([name,reg_starter,reg_main,reg_dessert,veg_starter,veg_main,veg_dessert,extra,save])
        
    }
    
    @objc func save_clicked(){
        Firebase.shared.save(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
