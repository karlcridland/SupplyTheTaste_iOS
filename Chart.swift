//
//  Chart.swift
//  resupply the taste
//
//  Created by Karl Cridland on 06/03/2021.
//

import Foundation
import UIKit

class Chart: UIView {
    
    let x_axis: UIView
    let y_axis: UIView
    
    let color = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    
    override init(frame: CGRect){
        let gap = 60
        self.x_axis = UIView(frame: CGRect(x: CGFloat(gap), y: frame.height-52, width: frame.width-CGFloat(gap)-10, height: 2))
        self.y_axis = UIView(frame: CGRect(x: CGFloat(gap), y: 20, width: 2, height: frame.height-70))
        super .init(frame: frame)
        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.2)
    }
    
    private var order_count = [String:Int]()
    private var price_count = [String:Int]()
    private var max_value = 0
    var show_money = false
    
    func valid_month(month: Int, year: Int) -> Bool{
        if year == Date().get(.year){
            return true
        }
        return year == Date().get(.year)-1 && month > Date().get(.month)
    }
    
    func sort_data() {
        order_count = [String:Int]()
        price_count = [String:Int]()
        
        Settings.shared.orders.forEach { (order) in
            if let y = Int(order.id.split(separator: ":")[0]){
                if let m = Int(order.id.split(separator: ":")[1]){
                    if (valid_month(month: m, year: y)){
                        let month = months[m]
                        
                        if (order_count.keys.contains(month)){
                            order_count[month]! += 1
                        }
                        else{
                            order_count[month] = 1
                        }
                        if (price_count.keys.contains(month)){
                            price_count[month]! += order.total()
                        }
                        else{
                            price_count[month] = order.total()
                        }
                    }
                }
            }
        }
        plot()
    }
    
    func plot(){
        self.removeAll()
        max_value = 0
        if (show_money){
//            max_value = price_count.max(by: {$0 > $1})!.value
            price_count.forEach { (_,value) in
                if (value > max_value){
                    max_value = value
                }
            }
        }
        else{
//            max_value = order_count.max(by: {$0 > $1})!.value
            order_count.forEach { (_,value) in
                if (value > max_value){
                    max_value = value
                }
            }
        }
        
        [self.x_axis,self.y_axis].forEach { (axis) in
            self.addSubview(axis)
            axis.backgroundColor = color
        }
        
        var i = 0
        let max_height = self.y_axis.frame.height-6
        months.forEach { (month) in
            let width = (self.x_axis.frame.width)/12
            let m = UILabel(frame: CGRect(x: CGFloat(Int(self.x_axis.frame.minX)+(Int(width)*i)), y: self.x_axis.frame.maxY, width: width, height: 50))
            self.addSubview(m)
            m.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(0.5))
            m.textAlignment = .center
            m.text = String(month.first!)
            
            var v = order_count[month]
            if (show_money){
                v = price_count[month]
            }
            if let value = v{
                
                let height = ((CGFloat(100)/CGFloat(max_value))*CGFloat(value)/100)*max_height
                let gap = 10
                
                let bar = UIView(frame: CGRect(x: m.frame.minX+CGFloat(gap), y: 22+max_height-height, width: width-CGFloat((gap*2)), height: height))
                self.addSubview(bar)
                bar.layer.cornerRadius = bar.frame.width/2
                bar.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
                
                if (value == max_value){
                    bar.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
                }
                
                let v = UILabel(frame: CGRect(x: m.frame.minX-10, y: bar.frame.minY-14, width: m.frame.width+20, height: 14))
                self.addSubview(v)
                v.textColor = color
                v.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(0.5))
                v.textAlignment = .center
                v.text = String(value)
                if show_money{
                    v.text = "£\(value/100)"
                }
            }
            
            m.textColor = color
            
            i += 1
        }
        
        self.subviews.forEach { (subview) in
            if let label = subview as? UILabel{
                self.bringSubviewToFront(label)
            }
        }
        
        let y_axis_font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(0.5))
        
        let max = UILabel(frame: CGRect(x: 0, y: 10, width: self.x_axis.frame.minX, height: 20))
        self.addSubview(max)
        max.textAlignment = .center
        max.text = String(max_value)
        max.font = y_axis_font
        
        let min = UILabel(frame: CGRect(x: 0, y: self.x_axis.frame.maxY-10, width: self.x_axis.frame.minX, height: 20))
        self.addSubview(min)
        min.textAlignment = .center
        min.text = "0"
        min.font = y_axis_font
        
        [max,min].forEach { (label) in
            label.textColor = color
        }
        
        if (show_money){
            max.text = "£\(max_value/100)"
            min.text = "£0"
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
