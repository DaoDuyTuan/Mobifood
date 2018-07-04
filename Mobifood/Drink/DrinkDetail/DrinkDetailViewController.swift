//
//  DrinkDetailViewController.swift
//  Mobifood
//
//  Created by Duy Tuan on 6/6/18.
//  Copyright © 2018 Duy Tuan. All rights reserved.
//

import UIKit
import CoreData

class DrinkDetailViewController: UIViewController {
    @IBOutlet weak var lblIsAddedState: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var fruitImageView: UIImageView!
    @IBOutlet weak var numberPickerView: UIPickerView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblFruitName: UILabel!
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var btnAddToCart: UIButton!
    @IBOutlet weak var heightAlertView: NSLayoutConstraint!
    
    var images: [String] = []
    private var newAmount: Int = 0
    private var newPrice: Int = 0
    private var isCheckedAmount = false
    
    @IBOutlet weak var bgAlertView: UIView!
    var drinkDetail: Product!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for index in  stride(from: 50, through: 1, by: -1) {
            self.images.append("\(index)")
        }
        for index in  stride(from: 50, through: 1, by: -1) {
            self.images.append("\(index)")
        }
        numberPickerView.selectRow(images.count / 2 - 1, inComponent: 0, animated: true)
        self.newAmount = 1
        self.newPrice = self.newAmount * drinkDetail.productVariants.price
        self.isCheckedAmount = true
        
        self.btnClose.layer.cornerRadius = self.btnClose.frame.width/2
        self.btnClose.layer.masksToBounds = true
        
        self.numberPickerView.transform = CGAffineTransform(rotationAngle: 90 * (.pi/180))
        self.btnAddToCart.layer.masksToBounds = true
        self.btnAddToCart.layer.cornerRadius = 10.0
        self.bgAlertView.layer.masksToBounds = true
        self.bgAlertView.layer.cornerRadius = 10.0
    }
    
    override func viewDidLayoutSubviews() {
        let height = UIScreen.main.bounds.height
        if height < 667 || (height > 1000 && height < 1300) {
            heightAlertView.constant = 20
        }
    }

    @IBAction func addToCard(_ sender: Any) {
        if isCheckedAmount {
            var productWillAdd = Product()
            productWillAdd = self.drinkDetail
            productWillAdd.productVariants = Variant(price: self.newPrice)
            productWillAdd.amount = self.newAmount
            
            if CartViewController.cart.filter({ $0.productID == self.drinkDetail.productID }).count == 0 {
                CartViewController.cart.append(drinkDetail)
                ManagerLocalData.shareData.saveProduct(product: productWillAdd)
            } else {
                for (index, product) in CartViewController.cart.enumerated() {
                    if product.productID == self.drinkDetail.productID {
                        CartViewController.cart[index] = productWillAdd
                        ManagerLocalData.shareData.updateData(productWillUpdate: productWillAdd)
                        print(ManagerLocalData.shareData.fetchDataFromLocal(entity: "Products")[index].value(forKey: "amount") as Any)
                    }
                }
            }
            self.lblIsAddedState.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.lblIsAddedState.isHidden = true
            }
            self.isCheckedAmount = false
        }
    }
    
    var price: String = "" {
        didSet {
            self.lblPrice.text = price
        }
    }
    
    var fruitImage: String = "" {
        didSet {
            self.fruitImageView.sd_setImage(with: URL(string: self.fruitImage), placeholderImage: UIImage(named: "notimage"))
        }
    }
    
    var fruitName: String = "" {
        didSet {
            self.lblFruitName.text = fruitName
        }
    }
    
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchs: UITouch? = touches.first
        if touchs?.view == self.viewBg {
            Utils.setAnimation(view: self.view)
            self.dismiss(animated: false, completion: nil)
        }
    }
    @IBAction func close(_ sender: Any) {
        Utils.setAnimation(view: self.view)
        self.dismiss(animated: true, completion: nil)
    }
}
extension DrinkDetailViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.images.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row % 10)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.newPrice = (Int(images[row])! * drinkDetail.productVariants.price)
        self.newAmount = Int(images[row])!
        self.lblPrice.text = "\(Utils.formmatCurrentcy(fommater: "", price: self.newPrice as NSNumber))"
        self.isCheckedAmount = true
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 40, height: pickerView.frame.height)
        let label = UILabel(frame: view.frame)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17)
        label.text = images[row]
        view.addSubview(label)
        view.transform = CGAffineTransform(rotationAngle: -90 * (.pi / 180))
        return view
    }
}

extension DrinkViewController {
    func checkPriceAndAmountWillAddToCart() {
        
    }
}
