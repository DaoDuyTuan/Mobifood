//
//  CartViewController.swift
//  Mobifood
//
//  Created by Duy Tuan on 6/6/18.
//  Copyright © 2018 Duy Tuan. All rights reserved.
//

import UIKit

class CartViewController: UIViewController {

    static var cart: [Product] = []
    @IBOutlet weak var lblIsSelectedAll: UILabel!
    @IBOutlet weak var footerCartView: UIView!
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var MyCartHeader: UIView!
    @IBOutlet weak var btnBuy: UIButton!
    private var isCheckAll = false
    override func viewDidLoad() {
        super.viewDidLoad()

        let cartCell = UINib(nibName: "CartTableViewCell", bundle: nil)
        self.cartTableView.register(cartCell, forCellReuseIdentifier: "cartCell")
    }
    override func viewDidLayoutSubviews() {
        self.btnBuy.layer.cornerRadius = 15.0
        self.lblIsSelectedAll.layer.cornerRadius = self.lblIsSelectedAll.frame.width/2
        self.lblIsSelectedAll.layer.borderWidth = 1.0
        self.lblIsSelectedAll.layer.borderColor = UIColor.black.cgColor
        Utils.setHeader(view: MyCartHeader)
        Utils.setHeader(view: footerCartView)
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buy(_ sender: Any) {
        
    }
    @IBAction func chooseAll(_ sender: UIButton) {
        guard CartViewController.cart.count > 0 else {
            return
        }
        
//        if  !isCheckAll {
            for index in 0...CartViewController.cart.count - 1 {
                CartViewController.cart[index].isChecked = true
            }
            self.lblIsSelectedAll.layer.backgroundColor = UIColor.myGreen.cgColor
//            self.isCheckAll = true
//        } else {
//            for index in 0...CartViewController.cart.count - 1 {
//                CartViewController.cart[index].isChecked = false
//            }
//            self.lblIsSelectedAll.backgroundColor = UIColor.white
//            self.isCheckAll = false
//        }
        self.cartTableView.reloadData()
    }
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CartViewController.cart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath) as! CartTableViewCell
        let product = CartViewController.cart[indexPath.row]
        cell.lblName.text = product.productTitle
        cell.lblPrice.text = product.productPrice.isString
        cell.isItemSelected.tag = indexPath.row
        cell.delegate = self
        cell.itemImageView.sd_setImage(with: URL(string: product.productImage[0].src), placeholderImage: UIImage(named: "notimage"))
        
        if  product.isCheckedProduct {
            cell.isItemSelected.backgroundColor = UIColor.myGreen
            cell.isItemSelected.setTitle("✓", for: .normal)
            cell.isItemSelected.setTitleColor(UIColor.red, for: .normal)
        } else {
            cell.isItemSelected.backgroundColor = UIColor.white
            cell.isItemSelected.setTitle("", for: .normal)
            cell.isItemSelected.setTitleColor(UIColor.white, for: .normal)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.selectionStyle = .none
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0.3 * UIScreen.main.bounds.height
    }
}

extension CartViewController: ChooseProduct {
    func chooseProduct(index: Int, isChecked: Bool) {
//        CartViewController.cart[index].isChecked = isChecked
    }
}
