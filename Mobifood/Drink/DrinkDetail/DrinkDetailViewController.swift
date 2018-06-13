//
//  DrinkDetailViewController.swift
//  Mobifood
//
//  Created by Duy Tuan on 6/6/18.
//  Copyright © 2018 Duy Tuan. All rights reserved.
//

import UIKit

class DrinkDetailViewController: UIViewController {
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var fruitImageView: UIImageView!
    @IBOutlet weak var numberPickerView: UIPickerView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblFruitName: UILabel!
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var btnAddToCart: UIButton!
    var images: [String] = []
    private var newAmount: Int = 0
    private var newPrice: Int = 0
    @IBOutlet weak var bgAlertView: UIView!
    var drinkDetail: Product!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for index in 1...50 {
            self.images.append("\(index)")
        }
        
        self.btnClose.layer.cornerRadius = self.btnClose.frame.width/2
        self.btnClose.layer.masksToBounds = true
        
        self.numberPickerView.transform = CGAffineTransform(rotationAngle: 90 * (.pi/180))
        self.btnAddToCart.layer.masksToBounds = true
        self.btnAddToCart.layer.cornerRadius = 10.0
        self.bgAlertView.layer.masksToBounds = true
        self.bgAlertView.layer.cornerRadius = 10.0
        
    }

    @IBAction func addToCard(_ sender: Any) {
        newPrice = newPrice == 0 ? drinkDetail.productVariants.price : newPrice
        drinkDetail.productVariants = Variant(price: newPrice)
        CartViewController.cart.append(drinkDetail)
        Utils.alert(title: "Congratulation", message: "Added to your cart", addActionOk: true, addActionCancel: false, vc: self)
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
        return self.images[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.newPrice = (Int(images[row])! * drinkDetail.productVariants.price)
        self.newAmount = Int(images[row])!
        self.lblPrice.text = "\(Utils.formmatCurrentcy(fommater: "", price: newPrice as NSNumber))"
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
