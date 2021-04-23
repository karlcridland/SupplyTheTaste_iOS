//
//  Page.swift
//  DoorPay
//
//  Created by Karl Cridland on 05/02/2021.
//

import Foundation
import UIKit

class Page: UIView {
    
    let view = UIScrollView()
    let background: UIView
    var title: String
    
    private var home_buttons = false
    
    init(title: String) {
        self.title = title
        let screen_width = UIScreen.main.bounds.width
        let screen_height = UIScreen.main.bounds.height
        background = UIView(frame: CGRect(x: 0, y: Header.shared.frame.height, width: screen_width, height: screen_height-Settings.shared.lower_bound!-Header.shared.frame.height))
        super.init(frame: CGRect(x: screen_width, y: Header.shared.frame.height, width: screen_width, height: screen_height-Settings.shared.lower_bound!-Header.shared.frame.height))
        
        
        self.addSubview(view)
        self.view.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        
        self.backgroundColor = Settings.shared.home?.view.backgroundColor
        self.background.backgroundColor = self.backgroundColor?.withAlphaComponent(0.4)
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(moving)))
        self.clipsToBounds = true
        Pages.shared.append(self)
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.frame = CGRect(x: 0, y: self.frame.minY, width: self.frame.width, height: self.frame.height)
            
        }, completion: {_ in
            
            if let s = self.superview{
                s.addSubview(self.background)
                self.background.tag = -1
                s.bringSubviewToFront(self)
            }
            
        })
        
    }
    
    @objc func moving(_ gesture: UIPanGestureRecognizer){
        UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
        let translation = gesture.translation(in: self)
        let frame = gesture.view!
        if (frame.frame.minX + translation.x >= 0){
            var percentage = (100-(frame.frame.minX*frame.frame.width/800))/100
            if percentage < 0{
                percentage = 0
            }
            self.background.backgroundColor = self.background.backgroundColor?.withAlphaComponent(0.8*percentage)
            frame.center = CGPoint(x: frame.center.x + translation.x, y: frame.center.y)
            gesture.setTranslation(CGPoint.zero, in: self)
        }
        if (gesture.state == .ended){
            if (frame.frame.minX > frame.frame.width/4){
                self.background.removeFromSuperview()
                Pages.shared.remove()
            }
            else{
                cancelDisappear()
                UIView.animate(withDuration: 0.1, animations: {
                    self.frame = CGRect(x: 0, y: self.frame.minY, width: self.frame.width, height: self.frame.height)
                    self.background.backgroundColor = self.background.backgroundColor?.withAlphaComponent(0.4)
                })
            }
        }
    }
    
    func cancelDisappear(){}
    
    @objc func disappear(){
        self.background.removeFromSuperview()
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        })
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { timer in
            self.removeFromSuperview()
        }
        Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false) { timer in
            self.background.removeFromSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



