//
//  EditViewController.swift
//  Personal Restaurant Guide
//
//  Created by Elik on 31.03.2022.
//

import UIKit

class EditViewController: UIViewController {

    var restaurant: Restaurant!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var addresTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var tagTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.text = restaurant.name
        
        countryTextField.text = restaurant.address.country
        cityTextField.text = restaurant.address.city
        addresTextField.text = restaurant.address.address
        phoneTextField.text = restaurant.phone?.applyPatternOnNumbers(pattern: "+# (###) ###-####", replacementCharacter: "#")
        tagTextField.text = restaurant.tags.map({ $0.name }).joined(separator: ", ")
        
        phoneTextField.delegate = self
    }
    
    @IBAction func saveAction(_ sender: Any) {
        restaurant.name = nameTextField.text ?? ""
        let tags = tagTextField.text?.components(separatedBy: ", ").map({ Tag(name: $0)})
        
        restaurant.address = Address(address: addresTextField.text ?? "",
                                     city: cityTextField.text ?? "",
                                     country: countryTextField.text ?? "")
        restaurant.phone = phoneTextField.text
        restaurant.tags = tags ?? []
        RestaurantService.shared.save()
        
        navigationController?.popViewController(animated: true)
    }
}

extension EditViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty == false {
            if textField.text?.count == 17 {
                return false
            }
            let text = textField.text ?? "" + string
            
            textField.text = text.applyPatternOnNumbers(pattern: "+# (###) ###-####", replacementCharacter: "#")
        }
        
        return true
    }
}
