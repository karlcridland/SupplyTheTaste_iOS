//
//  ViewController.swift
//  resupply the taste
//
//  Created by Karl Cridland on 30/01/2021.
//

import UIKit

class ViewController: UIViewController {
    
    let screen = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    
    var explain = UILabel(frame: CGRect(x: UIScreen.main.bounds.width/2-150, y: UIScreen.main.bounds.height/2-50, width: 300, height: 30))
    var status_bar = UIView(frame: CGRect(x: UIScreen.main.bounds.width/2-100, y: UIScreen.main.bounds.height/2, width: 200, height: 3))
    var status_ = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 4))

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        UIApplication.shared.windows.forEach { window in
            window.overrideUserInterfaceStyle = .light
        }
        
        Settings.shared.home = self
        UIApplication.shared.windows.forEach { window in
            window.overrideUserInterfaceStyle = .light
        }
        
        self.view.addSubview(self.screen)
        self.screen.layer.zPosition = 101
        Settings.shared.screen = screen
        self.screen.addSubview([self.status_bar,self.explain])
        self.status_bar.addSubview(self.status_)
        self.screen.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.status_bar.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        self.status_.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        self.explain.textAlignment = .center
        self.explain.text = "fetching orders..."
        self.explain.font = .systemFont(ofSize: 18, weight: UIFont.Weight(rawValue: 0.4))
        
        [self.status_,self.status_bar].forEach { (view) in
            view.layer.cornerRadius = view.frame.height/2
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false, block: { _ in
            if let layout = self.view.superview?.layoutMargins{
                Settings.shared.upper_bound = layout.top
                Settings.shared.lower_bound = layout.bottom
                
                self.view.addSubview([Header.shared,Menu.shared])
                self.startup()
                
                self.view.bringSubviewToFront(self.screen)
                
            }
        })
        
    }
    
    func update_screen(ready: Int, total: Int) {
        let width = self.status_bar.frame.width/CGFloat(total)
        self.status_.frame = CGRect(x: 0, y: 0, width: Int(width)*ready, height: 4)
    }
    
    func startup() {
        Firebase.shared.get_orders()
        Firebase.shared.get_menus()
        Firebase.shared.get_tags()
        
        let statistics = Statistics(frame: CGRect(x: 0, y: Header.shared.frame.maxY, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-Header.shared.frame.maxY))
        
        self.view.addSubview([statistics,Menu.shared])
    }

}

