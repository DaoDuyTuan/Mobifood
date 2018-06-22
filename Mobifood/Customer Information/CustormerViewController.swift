//
//  CustormerViewController.swift
//  Mobifood
//
//  Created by Duy Tuan on 6/17/18.
//  Copyright © 2018 Duy Tuan. All rights reserved.
//

import UIKit

class CustormerViewController: UIViewController {

    
    @IBOutlet weak var heightScrollView: NSLayoutConstraint!
    @IBOutlet var viewContainer: UIView!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet var inforCollectionTF: [UITextField]!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for tf in inforCollectionTF {
            self.setBorderTF(textField: tf, color: UIColor(displayP3Red: 184/255, green: 184/255, blue: 184/255, alpha: 184/255))
            tf.delegate = self
        }
        
        self.btnConfirm.layer.cornerRadius = 5.0
        self.btnConfirm.layer.masksToBounds = true
    }

    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        if UIScreen.main.bounds.height > 1000 {
            self.heightScrollView.constant = UIScreen.main.bounds.height + 100
        }
    }
    @IBAction func confirm(_ sender: Any) {
        for info in self.inforCollectionTF {
            if (info.text?.trimmingCharacters(in: .whitespacesAndNewlines).elementsEqual(""))! {
                self.alertValidate(content: "Điền đầy đủ thông tin")
                return
            }
            
            guard (self.inforCollectionTF[1].text?.contains("@gmail.com"))! else {
                self.alertValidate(content: "Email không hợp lệ")
                return
            }
        }
    }
    
    func setBorderTF(textField: UITextField, color: UIColor) {
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = self.setColor(color: color).cgColor
        textField.layer.cornerRadius = 5.0
    }
    
    func setColor(color: UIColor) -> UIColor{
        return color
    }
    
    func alertValidate(content: String) {
        let alert = UIAlertController(title: "Thông báo", message: content, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension CustormerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.inforCollectionTF[2] {
            textField.keyboardType = UIKeyboardType.decimalPad
            return
        }
        textField.becomeFirstResponder()
    }
}
