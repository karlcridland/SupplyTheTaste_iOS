//
//  Statistics.swift
//  resupply the taste
//
//  Created by Karl Cridland on 06/03/2021.
//

import Foundation
import UIKit

class Statistics: UIScrollView {
    
    let chart = Chart(frame: CGRect(x: 0, y: 50, width: UIScreen.main.bounds.width, height: 280))
    let dishes = UITextView()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        Settings.shared.stats = self
        
        self.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        
        let title_font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight(rawValue: 0.3))
        let title_align = NSTextAlignment.right
        
        let chart_title = UILabel(frame: CGRect(x: 20, y: 10, width: self.frame.width-40, height: 30))
        chart_title.text = "monthly breakdown"
        chart_title.textAlignment = title_align
        chart_title.font = title_font
        
        let chart_switch = UISegmentedControl(items: ["no. orders", "income"])
        chart_switch.frame = CGRect(x: 10, y: chart.frame.maxY+10, width: self.frame.width-20, height: 40)
//        self.chart.frame = CGRect(x: self.chart.frame.minX, y: 0, width: self.chart.frame.width, height: self.chart.frame.height)
        
        chart_switch.addTarget(self, action: #selector(switch_clicked), for: .valueChanged)
        chart_switch.selectedSegmentIndex = 0
        chart_switch.overrideUserInterfaceStyle = .dark
        
        let popular = UILabel(frame: CGRect(x: 20, y: chart_switch.frame.maxY+20, width: self.frame.width-40, height: 30))
        popular.text = "most popular dishes"
        popular.textAlignment = title_align
        popular.font = title_font
        
        self.dishes.frame = CGRect(x: popular.frame.minX-5, y: popular.frame.maxY+10, width: popular.frame.width+10, height: 220)
        self.dishes.font = .systemFont(ofSize: 15, weight: UIFont.Weight(rawValue: 0.3))
        self.dishes.isUserInteractionEnabled = false
        self.dishes.backgroundColor = .clear
        
        self.contentSize = CGSize(width: self.frame.width, height: dishes.frame.maxY)
        
        self.addSubview([chart_title,self.chart,chart_switch,popular,self.dishes])
        [chart_title,popular,self.dishes].forEach { (label) in
            if let label = label as? UILabel{
                label.textColor = .white
            }
            if let label = label as? UITextView{
                label.textColor = .white
            }
        }
    }
    
    @objc func switch_clicked(sender: UISegmentedControl){
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        chart.show_money = sender.selectedSegmentIndex == 1
        if (Settings.shared.orders.count > 0){
            chart.plot()
        }
    }
    
    func update(){
        var meal_count = [String:Int]()
        Settings.shared.orders.forEach { (order) in
            order.basket.forEach { (item) in
                if (meal_count.keys.contains(item.title)){
                    meal_count[item.title]! += 1
                }
                else{
                    meal_count[item.title] = 1
                }
            }
        }
        let sorted = meal_count.sorted(by: {$0.value > $1.value})
        var i = 0
        var str = ""
        sorted.forEach { (key,value) in
            if (i < 5){
                str += "\(i+1). \(key) (\(value))\n\n"
            }
            i += 1
        }
        str.removeLast()
        str.removeLast()
        dishes.text = str
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
