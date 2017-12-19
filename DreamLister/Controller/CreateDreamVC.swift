//
//  CreateDreamVC.swift
//  DreamLister
//
//  Created by Vibhanshu Vaibhav on 02/12/17.
//  Copyright © 2017 Vibhanshu Vaibhav. All rights reserved.
//

import UIKit
import CoreData
import UITextView_Placeholder



class CreateDreamVC: UIViewController {

    @IBOutlet weak var titleTextField: InsetTextField!
    @IBOutlet weak var priceTextField: InsetTextField!
    @IBOutlet weak var descriptionTextView: InsetTextView!
    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var addDreamButton: UIButton!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    let picker = UIImagePickerController()
    
    var imagePicked = false
    var selectedStore = String()
    var stores = ["Flipkart","Snapdeal","Croma","Amazon","Jabong","Myntra","Nyka","CarDekho","Other"]
    var itemPresented: Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storePicker.delegate = self
        storePicker.dataSource = self
        picker.delegate = self
        priceTextField.delegate = self
        descriptionTextView.delegate = self
        descriptionTextView.placeholder = "Description"
        descriptionTextView.placeholderColor = UIColor.lightGray
        if itemPresented != nil {
            displayInformation()
            navigationItem.title = "Edit Dream"
        } else {
            deleteButton.isEnabled = false
            deleteButton.tintColor = UIColor.clear
        }
        addDreamButton.setDisabled()
        setBackButton()
    }
    
    func setBackButton() {
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    func initData(item: Item) {
        self.itemPresented = item
    }
    
    func displayInformation() {
        self.titleTextField.text = itemPresented?.title
        let price = itemPresented?.price.description
        if price?.split(separator: ".")[1] == "0" {
            self.priceTextField.text = price?.split(separator: ".")[0].description
        } else {
            self.priceTextField.text = price
        }
        self.descriptionTextView.text = itemPresented?.details
        if itemPresented?.image == nil {
            self.thumbImageView.image = UIImage(named: "imagePick")
        } else {
            imagePicked = true
            self.thumbImageView.image = itemPresented?.image as? UIImage
        }
        var index = 0
        for store in stores {
            if store == itemPresented?.store {
                selectedStore = store
                self.storePicker.selectRow(index, inComponent: 0, animated: false)
            }
            index = index + 1
        }
    }
    
    @IBAction func pickImageButtonPressed(_ sender: Any) {
        if itemPresented != nil {
            addDreamButton.setEnabled()
        }
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func saveDreamButtonPressed(_ sender: Any) {
        save { (complete) in
            if complete {
                navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        remove { (complete) in
            if complete {
                navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func textFieldChanged(_ sender: Any) {
        setButtonStatus()
    }
    
    func setButtonStatus() {
        if titleTextField.text == "" || priceTextField.text == "" || descriptionTextView.text == "" {
            addDreamButton.setDisabled()
        } else {
            addDreamButton.setEnabled()
        }
    }
    
}

extension CreateDreamVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = NSCharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}

extension CreateDreamVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        setButtonStatus()
    }
}

extension CreateDreamVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePicked = true
            thumbImageView.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

extension CreateDreamVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stores.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let store = stores[row]
        return store
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if itemPresented != nil{
            if stores[row] != selectedStore {
                addDreamButton.setEnabled()
            }
        } else {
            selectedStore = stores[row]
        }
    }
    
}

extension CreateDreamVC {
    
    func save(completion: (_ complete: Bool) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        var item: Item!
        
        if itemPresented != nil {
            item = itemPresented
        } else {
            item = Item(context: managedContext)
        }
        
        item.created = NSDate() as Date
        item.title = titleTextField.text
        item.price = (priceTextField.text?.toDouble())!
        item.details = descriptionTextView.text
        item.store = selectedStore
        if imagePicked {
            item.image = thumbImageView.image
        } else {
            item.image = nil
        }
        
        
        
        do {
            try managedContext.save()
            debugPrint("Successfully saved")
            completion(true)
        } catch {
            debugPrint("Could not save: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    func remove(completion: (_ complete: Bool) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        managedContext.delete(itemPresented!)
        
        do {
            try managedContext.save()
            debugPrint("Successfully deleted")
            completion(true)
        } catch {
            debugPrint("Could not delete: \(error.localizedDescription)")
            completion(false)
        }
    }
    
}
