//
//  Pages.swift
//  DoorPay
//
//  Created by Karl Cridland on 05/02/2021.
//

import Foundation
import UIKit

class Pages {
    
    public static let shared = Pages()
    private var pages = [Page]()
    public var has_pages = false
    
    private init(){}
    
    func append(_ page: Page){
        pages.append(page)
        
        if let home = Settings.shared.home{
            home.view.addSubview(page)
        }
        
        
        update()
    }
    
    func last() -> Page?{
        return pages.last
    }
    
    @objc func remove(){
        if let last = pages.last{
            last.disappear()
            pages.removeLast()
            
        }
        
        update()
        
    }
    
    func removeAll(){
        while pages.count > 0{
            remove()
        }
    }
    
    func update(){
        if let last = pages.last{
            Header.shared.update_title(last.title)
            has_pages = true
        }
        else{
            Header.shared.update_title("Supply The Taste")
            has_pages = false
        }
        Header.shared.update_icon(has_pages)
    }
    
    func update_orders_page(){
        for page in pages{
            if let p = page as? PageOrders{
                p.display()
            }
        }
    }
}
