//
//  PageEditMenu.swift
//  resupply the taste
//
//  Created by Karl Cridland on 04/03/2021.
//

import Foundation
import UIKit
import FirebaseDatabase

class PageEditMenu: Page, UITextViewDelegate {
    
    let menu: FoodMenu
    
    private var pounds: InputField?
    private var pence: InputField?
    private var vegetarian: UISwitch?
    
    let status = UISegmentedControl(items: ["in stock","out of stock"])
    
    init(menu: FoodMenu) {
        self.menu = menu
        super.init(title: menu.title)
        
        self.status.frame = CGRect(x: 10, y: 10, width: self.view.frame.width-20, height: 50)
        self.status.layer.borderWidth = 2
        self.status.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        let font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(0.2))
        self.status.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        self.status.addTarget(self, action: #selector(toggle_archive), for: .valueChanged)
        self.status.selectedSegmentIndex = 0
        if (!self.menu.in_stock){
            self.status.selectedSegmentIndex = 1
        }
        
        let title = InputField(title: "title", frame: CGRect(x: 10, y: status.frame.maxY+10, width: self.frame.width-20, height: 50))
        title.input.text = menu.title
        
        let desc = InputFieldMultiline(title: "description", frame: CGRect(x: 10, y: title.frame.maxY+10, width: self.frame.width-20, height: 100))
        desc.multi.text = menu.subtitle
        
        let allergens = InputField(title: "allergens", frame: CGRect(x: 10, y: desc.frame.maxY+10, width: self.frame.width-20, height: 50))
        allergens.input.text = menu.allergens
        
        pounds = InputField(title: "pounds", frame: CGRect(x: 10, y: allergens.frame.maxY+10, width: self.frame.width-130, height: 50))
        pounds!.input.text = "\(menu.price/100)"
        pounds!.input.textAlignment = .right
        pounds!.input.frame = CGRect(x: pounds!.input.frame.minX, y: pounds!.input.frame.minY, width: pounds!.input.frame.width-10, height: pounds!.input.frame.height)
        
        pence = InputField(title: "pence", frame: CGRect(x: self.frame.width-110, y: allergens.frame.maxY+10, width: 100, height: 50))
        pence!.input.text = "\(menu.price%100)"
        pence!.input.textAlignment = .center
        
        let category = UIScrollView(frame: CGRect(x: 10, y: pounds!.frame.maxY+10, width: self.frame.width-20, height: 50))
        set_up_category(category)
        
        let tags = UIScrollView(frame: CGRect(x: 10, y: category.frame.maxY+10, width: self.frame.width-20, height: 50))
        set_up_tags(tags)
        
        let servings = ["one":1,"two":2,"three":3,"four":4]
        let serve_label = UILabel(frame: CGRect(x: 10, y: tags.frame.maxY+10, width: self.frame.width-20, height: 50))
        serve_label.text = "serves: \(servings[menu.serves]!)"
        
        let spicy_label = UILabel(frame: CGRect(x: 10, y: serve_label.frame.maxY+10, width: self.frame.width-20, height: 50))
        spicy_label.text = "spiciness: 0"
        
        let veg_label = UILabel(frame: CGRect(x: 10, y: spicy_label.frame.maxY+10, width: self.frame.width-20, height: 50))
        veg_label.text = "vegetarian:"
        
        let vegan_label = UILabel(frame: CGRect(x: 10, y: veg_label.frame.maxY+10, width: self.frame.width-20, height: 50))
        vegan_label.text = "vegan:"
        
        let instruct_label = UILabel(frame: CGRect(x: 10, y: vegan_label.frame.maxY+10, width: self.frame.width-20, height: 50))
        instruct_label.text = "instructions:"
        
        let serves = Stepper(frame: CGRect(x: serve_label.frame.maxX-95, y: serve_label.frame.minY+8, width: 100, height: serve_label.frame.height))
        serves.addTarget(self, action: #selector(stepperChanged), for: .valueChanged)
        serves.label = serve_label
        serves.placeholder = "serves: "
        serves.maximumValue = 4
        serves.minimumValue = 1
        serves.value = Double(servings[menu.serves]!)
        
        let spicy = Stepper(frame: CGRect(x: spicy_label.frame.maxX-95, y: spicy_label.frame.minY+8, width: 100, height: spicy_label.frame.height))
        spicy.addTarget(self, action: #selector(stepperChanged), for: .valueChanged)
        spicy.label = spicy_label
        spicy.placeholder = "spiciness: "
        spicy.maximumValue = 3
        spicy.minimumValue = 0
        
        vegetarian = UISwitch(frame: CGRect(x: veg_label.frame.maxX-50, y: veg_label.frame.minY+8, width: 60, height: veg_label.frame.height))
        let vegan = UISwitch(frame: CGRect(x: vegan_label.frame.maxX-50, y: vegan_label.frame.minY+8, width: 60, height: vegan_label.frame.height))
        let instructions = UISwitch(frame: CGRect(x: instruct_label.frame.maxX-50, y: instruct_label.frame.minY+8, width: 60, height: instruct_label.frame.height))
        vegetarian!.onTintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        vegan.onTintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        instructions.onTintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        vegetarian!.isOn = menu.vegetarian
        vegan.isOn = menu.vegan
        instructions.isOn = menu.instructions
        
        let save = UIButton(frame: CGRect(x: 3*UIScreen.main.bounds.width/4-75, y: instructions.frame.maxY+20, width: 150, height: 40))
        save.titleLabel?.font = .systemFont(ofSize: 18, weight: UIFont.Weight(0.4))
        save.setTitle("save all", for: .normal)
        save.setTitleColor(.white, for: .normal)
        save.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        save.layer.cornerRadius = 8
        
        let delete = UIButton(frame: CGRect(x: UIScreen.main.bounds.width/4-75, y: instructions.frame.maxY+20, width: 150, height: 40))
        delete.titleLabel?.font = .systemFont(ofSize: 18, weight: UIFont.Weight(0.4))
        delete.setTitle("delete", for: .normal)
        delete.setTitleColor(#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), for: .normal)
        delete.layer.cornerRadius = 8
        
        self.view.addSubview([status,title,desc,allergens,pounds!,pence!,category,serve_label,serves,spicy_label,spicy,veg_label,vegan_label,vegan,vegetarian!,instruct_label,instructions,save,delete])
        
        title.input.addTarget(self, action: #selector(update_title), for: .allEditingEvents)
        desc.multi.delegate = self
        allergens.input.addTarget(self, action: #selector(update_allergens), for: .allEditingEvents)
        spicy.addTarget(self, action: #selector(update_spiciness), for: .allEvents)
        serves.addTarget(self, action: #selector(update_serves), for: .allEvents)
        vegetarian!.addTarget(self, action: #selector(update_veg), for: .touchUpInside)
        vegan.addTarget(self, action: #selector(update_vegan), for: .touchUpInside)
        instructions.addTarget(self, action: #selector(update_instructions), for: .touchUpInside)
        
        pounds?.input.addTarget(self, action: #selector(update_price), for: .allEditingEvents)
        pence?.input.addTarget(self, action: #selector(update_price), for: .allEditingEvents)
        pence?.input.addTarget(self, action: #selector(edit_pence), for: .editingChanged)
        pounds?.input.keyboardType = .numberPad
        pence?.input.keyboardType = .numberPad
        check_pence()
        
        self.view.contentSize = CGSize(width: self.view.frame.width, height: self.view.maxY()+30)
        save.addTarget(self, action: #selector(save_all), for: .touchUpInside)
        
    }
    
    @objc func toggle_archive(sender: UISegmentedControl){
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        self.menu.in_stock = sender.selectedSegmentIndex == 0
    }
    
    func textViewDidChange(_ textView: UITextView) {
        menu.subtitle = textView.text!
        print(menu.subtitle)
    }
    
    func can_save() -> Bool {
        if menu.title.count > 0 && menu.subtitle.count > 0{
            if let _ = menu.type{
                return true
            }
            else{
                alert("add a category")
                return false
            }
        }
        alert("you need a title and description")
        return false
    }
    
    func alert(_ message: String){
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "okay", style: .default, handler: nil))
    }
    
    @objc func save_all(){
        if (can_save()){
            Firebase.shared.save_meals()
        }
    }
    
    func check_pence(){
        if let pence = Int(self.pence!.input.text!){
            if (pence < 10){
                self.pence!.input.text = "0\(pence)"
            }
        }
    }
    
    @objc func update_title(sender: UITextField){
        menu.title = sender.text!
        self.title = sender.text!
        if (sender.text!.count == 0){
            self.title = "New Menu"
        }
        Pages.shared.update()
    }
    
    @objc func update_desc(sender: UITextView){
    }
    
    @objc func update_allergens(sender: UITextField){
        menu.allergens = sender.text!
    }
    
    @objc func update_spiciness(sender: Stepper){
        menu.spiciness = Int(sender.value)
    }
    
    @objc func update_serves(sender: Stepper){
        let servings = [1:"one",2:"two",3:"three",4:"four"]
        menu.serves = servings[Int(sender.value)]!
    }
    
    @objc func edit_pence(sender: UITextField){
        if let price = Int(sender.text!){
            if (price > 99){
                sender.text = "\(price%100)"
                update_price()
            }
        }
    }
    
    @objc func exit_price(){
        check_pence()
    }
    
    @objc func update_price(){
        if let pounds = Int(self.pounds!.input.text!){
            if let pence = Int(self.pence!.input.text!){
                menu.price = (pounds*100)+pence
            }
        }
    }
    
    @objc func stepperChanged(sender: Stepper){
        if let label = sender.label{
            if let placeholder = sender.placeholder{
                label.text = placeholder+"\(Int(sender.value))"
            }
        }
    }
    
    @objc func update_veg(sender: UISwitch){
        menu.vegetarian = sender.isOn
    }
    
    @objc func update_vegan(sender: UISwitch){
        menu.vegan = sender.isOn
        if let vegetarian = vegetarian{
            if (sender.isOn){
                vegetarian.isOn = true
                update_veg(sender: vegetarian)
            }
        }
    }
    
    @objc func update_instructions(sender: UISwitch){
        menu.instructions = sender.isOn
    }
    
    func set_up_category(_ category: UIScrollView){
        category.layer.borderWidth = 2
        category.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        category.layer.cornerRadius = 8
        category.showsHorizontalScrollIndicator = false
        
        let label = UILabel(frame: CGRect(x: 20, y: category.frame.minY+5, width: frame.width-20, height: 12))
        label.font = .systemFont(ofSize: 12)
        label.text = "category"
        self.view.addSubview([label,category])
        
        var i = 0
        let width = 70
        var buttons = [ArrayButton]()
        for type in ["starters","main","dessert","side","misc"]{
            let button = ArrayButton(frame: CGRect(x: 10+(i*(width+10)), y: 14, width: width, height: 34))
            buttons.append(button)
            button.setTitle(type, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.addTarget(self, action: #selector(update_category), for: .touchUpInside)
            category.addSubview(button)
            category.contentSize = CGSize(width: button.frame.maxX + 10, height: 50)
            button.titleLabel?.font = .systemFont(ofSize: 16, weight: UIFont.Weight(0.4))
            
            if (menu.type == type){
                button.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)
            }
            
            i += 1
        }
        buttons.forEach { (button) in
            button.array = buttons
        }
    }
    
    func set_up_tags(_ tags: UIScrollView){
        tags.layer.borderWidth = 2
        tags.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        tags.layer.cornerRadius = 8
        tags.showsHorizontalScrollIndicator = false
        
        let label = UILabel(frame: CGRect(x: 20, y: tags.frame.minY+5, width: frame.width-20, height: 12))
        label.font = .systemFont(ofSize: 12)
        label.text = "tags"
        self.view.addSubview([label,tags])
        
        var i = 0
        let width = 70
        var buttons = [ArrayButton]()
        for type in Settings.shared.tags{
            let button = ArrayButton(frame: CGRect(x: 10+(i*(width+10)), y: 14, width: width, height: 34))
            buttons.append(button)
            button.setTitle(type, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.addTarget(self, action: #selector(update_tags), for: .touchUpInside)
            tags.addSubview(button)
            tags.contentSize = CGSize(width: button.frame.maxX + 10, height: 50)
            button.titleLabel?.font = .systemFont(ofSize: 16, weight: UIFont.Weight(0.4))
            button.value = type
            
            if (menu.tags.contains(type)){
                button.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)
                button.clicked = true
            }
            
            i += 1
        }
        buttons.forEach { (button) in
            button.array = buttons
        }
    }
    
    @objc func update_category(sender: ArrayButton){
        sender.array.forEach { (button) in
            button.setTitleColor(.black, for: .normal)
        }
        sender.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)
        menu.type = sender.titleLabel?.text
    }
    
    @objc func update_tags(sender: ArrayButton){
        sender.clicked = !sender.clicked
        menu.tags = []
        sender.array.forEach { (button) in
            if (button.clicked){
                button.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)
                menu.tags.append(button.value)
            }
            else{
                button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            }
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Stepper: UIStepper {
    var label: UILabel?
    var placeholder: String?
}

class ArrayButton: UIButton {
    var array = [ArrayButton]()
    var clicked = false
    var value = ""
}

class InputField: UIView {
    
    let input = UITextField()
    private let button: UIButton
    
    init(title: String, frame: CGRect) {
        self.button = UIButton(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        super .init(frame: frame)
        
        self.layer.borderWidth = 2
        self.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        self.layer.cornerRadius = 8
        self.backgroundColor = .white
        
        let label = UILabel(frame: CGRect(x: 10, y: 3, width: frame.width-20, height: 16))
        label.font = .systemFont(ofSize: 12)
        label.text = title
        
        self.input.frame = CGRect(x: 10, y: 15, width: frame.width-20, height: frame.height-20)
        self.addSubview([label,button,input])
        
        self.input.returnKeyType = .done
        self.input.backgroundColor = .clear
        button.addTarget(self, action: #selector(button_clicked), for: .touchUpInside)
    }
    
    @objc func button_clicked(){
        input.becomeFirstResponder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class InputFieldMultiline: InputField {
    
    let multi = UITextView()
    override init(title: String, frame: CGRect) {
        super .init(title: title, frame: frame)
        input.removeFromSuperview()
        
        self.multi.font = self.input.font
        self.multi.backgroundColor = .clear
        self.multi.frame = CGRect(x: 5, y: 15, width: frame.width-10, height: frame.height-20)
        self.addSubview(multi)
        
    }
    
    @objc override func button_clicked() {
        multi.becomeFirstResponder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
