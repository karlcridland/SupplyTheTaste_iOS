//
//  Header.swift
//  resupply the taste
//
//  Created by Karl Cridland on 21/02/2021.
//

import Foundation
import UIKit

class Header: UIView {
    
    public static let shared = Header()
    
    private let menu = UIButton(frame: CGRect(x: 0, y: Settings.shared.upper_bound!, width: 70, height: 70))
    private let title = UILabel(frame: CGRect(x: 80, y: Settings.shared.upper_bound!, width: UIScreen.main.bounds.width-110, height: 70))
    
    private var is_open = false
    
    private init() {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 70+Settings.shared.upper_bound!))
        self.addSubview([menu,title])
        self.set_up_menu()
        self.set_up_title()
        
        self.layer.shadowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = .init(width: 0, height: 10)
        self.layer.shadowRadius = 15
        self.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.layer.zPosition = 100
    }
    
    func set_up_title(){
        self.title.text = "Supply The Taste"
        self.title.textAlignment = .right
        self.title.font = UIFont.systemFont(ofSize: 23, weight: UIFont.Weight(0.5))
    }
    
    func set_up_menu(){
        self.menu.setImage(UIImage(named: "menu_button"), for: .normal)
        self.menu.setImage(UIImage(named: "menu_button_blue"), for: .highlighted)
        self.menu.addTarget(self, action: #selector(menu_clicked), for: .touchUpInside)
    }
    
    func update_title(_ text: String){
        self.title.text = text
    }
    
    @objc func menu_clicked(){
        if (Pages.shared.has_pages){
            Pages.shared.remove()
        }
        else{
            self.is_open = !self.is_open
            Menu.shared.activate()
        }
    }
    
    func sign_out(){
//        Menu.shared.activate(self.is_open)
    }
    
    func update_icon(_ has_pages: Bool){
        if (has_pages){
            self.menu.setImage(UIImage(named: "back"), for: .normal)
            self.menu.setImage(UIImage(named: "back_blue"), for: .highlighted)
        }
        else{
            self.menu.setImage(UIImage(named: "menu_button"), for: .normal)
            self.menu.setImage(UIImage(named: "menu_button_blue"), for: .highlighted)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIView{
    func addSubview(_ views: [UIView]){
        for view in views{
            addSubview(view)
        }
    }
    
    func removeAll(){
        for subview in self.subviews{
            subview.removeFromSuperview()
        }
    }
    
    func gradient(left: UIColor, right: UIColor, corner: CGFloat) {
        layer.sublayers?.remove(at: 0)
        let gradientLayer = CAGradientLayer()
        gradientLayer.cornerRadius = corner
        gradientLayer.colors = [left.cgColor, right.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
    func maxY() -> CGFloat{
        if let a = self as? UIScrollView{
            a.showsVerticalScrollIndicator = false
            a.showsHorizontalScrollIndicator = false
        }
        if let y = self.subviews.sorted(by: {$0.frame.maxY < $1.frame.maxY}).last?.frame.maxY{
            return y
        }
        return 0
    }
}
