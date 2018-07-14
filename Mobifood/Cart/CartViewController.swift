//
//  CartViewController.swift
//  Mobifood
//
//  Created by Duy Tuan on 6/6/18.
//  Copyright © 2018 Duy Tuan. All rights reserved.
//

import UIKit

class CartViewController: UIViewController {

    static var cart: [Product] = [] {
        didSet{
            HomeViewController.countItemInCart = cart.count
            NotificationCenter.default.post(name: .countCart, object: nil)
        }
    }
    @IBOutlet weak var lblIsSelectedAll: UILabel!
    @IBOutlet weak var footerCartView: UIView!
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var MyCartHeader: UIView!
    @IBOutlet weak var btnBuy: UIButton!
    private var isCheckAll = false
    @IBOutlet weak var lblIsHaveCombor: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if CartViewController.cart.count > 0 {
            self.lblIsHaveCombor.isHidden = true
        }
        let cartCell = UINib(nibName: "CartTableViewCell", bundle: nil)
        self.cartTableView.register(cartCell, forCellReuseIdentifier: "cartCell")
    }
    override func viewDidLayoutSubviews() {
        self.btnBuy.layer.cornerRadius = 15.0
        self.lblIsSelectedAll.layer.cornerRadius = self.lblIsSelectedAll.frame.width/2
        self.lblIsSelectedAll.layer.borderWidth = 1.0
        self.lblIsSelectedAll.layer.borderColor = UIColor.black.cgColor
        self.lblIsSelectedAll.layer.backgroundColor = UIColor.clear.cgColor
        Utils.setHeader(view: MyCartHeader)
        Utils.setHeader(view: footerCartView)
    }
    
    @IBAction func removeProductInCart(_ sender: Any) {
        let itemsWillRemoveFromCart = CartViewController.cart.filter({ $0.isCheckedProduct == false })
        let itemsRetainAfterDelete = CartViewController.cart.filter({ $0.isCheckedProduct == true })
        
        CartViewController.cart = itemsWillRemoveFromCart
        if CartViewController.cart.count == 0 {
            self.lblIsHaveCombor.isHidden = false
            self.lblIsSelectedAll.layer.backgroundColor = UIColor.clear.cgColor            
        }
        self.cartTableView.reloadData()
        
        for product in itemsRetainAfterDelete {
            ManagerLocalData.shareData.deleteData(productWillDelete: product)
        }
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buy(_ sender: Any) {
        if CartViewController.cart.count > 0 {
            let vc = CustormerViewController(nibName: "CustormerViewController", bundle: nil)
            Utils.setAnimation(view: self.view)
            self.present(vc, animated: true, completion: nil)
        } else {
            let _ = MyAlert().showAlert("Giỏ hàng không có sản phẩm!!")
        }
    }
    @IBAction func chooseAll(_ sender: UIButton) {
        guard CartViewController.cart.count > 0 else {
            return
        }
        
        if  !isCheckAll {
            for index in 0...CartViewController.cart.count - 1 {
                CartViewController.cart[index].isChecked = true
            }
            self.lblIsSelectedAll.layer.backgroundColor = UIColor.myGreen.cgColor
            self.isCheckAll = true
        } else {
            for index in 0...CartViewController.cart.count - 1 {
                CartViewController.cart[index].isChecked = false
            }
            self.lblIsSelectedAll.layer.backgroundColor = UIColor.clear.cgColor
            self.isCheckAll = false
        }
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
        cell.lblAmount.text = "\(product.amount ?? 1)"
        
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
        let drink = CartViewController.cart[indexPath.row]
        let vc = DrinkDetailViewController(nibName: "DrinkDetailViewController", bundle: nil)
         vc.drinkDetail = drink
        DrinkDetailModelView.drinkDetailModelView.setViewWillShow(vc: vc)
        DrinkDetailModelView.drinkDetailModelView.setDataForDrinkDetail(vc: vc, with: drink)
        Utils.setAnimation(view: self.view)
        vc.completionAfterDimiss = {
            self.cartTableView.reloadData()
        }
        UIView.animate(withDuration: 1.5, animations: {
            self.present(vc, animated: false, completion: nil)
        })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0.3 * UIScreen.main.bounds.height
    }
}

extension CartViewController: ChooseProduct {
    func chooseProduct(index: Int, isChecked: Bool) {
        guard isChecked else {
            return
        }
        
        if CartViewController.cart.filter({$0.isCheckedProduct == false}).count > 0 {
            self.lblIsSelectedAll.layer.backgroundColor = UIColor.clear.cgColor
        } else {
            self.lblIsSelectedAll.layer.backgroundColor = UIColor.myGreen.cgColor
        }
    }
}
