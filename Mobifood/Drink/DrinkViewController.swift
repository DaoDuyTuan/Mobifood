//
//  DrinkViewController.swift
//  Mobifood
//
//  Created by Duy Tuan on 6/4/18.
//  Copyright © 2018 Duy Tuan. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import PromiseKit
import Alamofire
import SDWebImage
import SKActivityIndicatorView

class DrinkViewController: UIViewController, IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(image: UIImage(named: "ic_drink"))
    }
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var drinkTableView: UITableView!
    let images = ["1", "2", "3", "4", "5", "6", "7"]
    var drinks = [[Product]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibTableViewCell = UINib(nibName: "DrinkTableViewCell", bundle: nil)
        self.drinkTableView.register(nibTableViewCell, forCellReuseIdentifier: "drinkTableCell")
        self.loadingIndicator.hidesWhenStopped = true
        NetworkManager.whenNoConnection()
        NetworkManager.sharedInstance.reachability.whenReachable = {_ in
            Utils.warning(title: "Success", message: "Connected Internet", addActionOk: true, addActionCancel: false)
            self.drinks = [[Product]]()
            self.drinkTableView.reloadData()
            self.loadDrink()
        }
        NetworkManager.isReachable(completed: {_ in
            self.loadDrink()
        })
    }
}

extension DrinkViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.drinks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "drinkTableCell", for: indexPath) as! DrinkTableViewCell
        cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0.48 * self.view.frame.height
    }
}

extension DrinkViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.drinks[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "drinkCollectionCell" , for: indexPath) as! DrinkCollectionViewCell
        let drink = self.drinks[collectionView.tag][indexPath.row]
        cell.lblNameFruit.text = drink.productTitle
            cell.lblPriceFruit.text = "\(drink.productVariants.price)"
        
        cell.lblPriceFruit.text = "\(Utils.formmatCurrentcy(fommater: "", price: drink.productVariants.price as NSNumber) )"
        cell.imageFruitImageView.sd_setImage(with: URL(string:
            drink.productImage.count > 0 ? drink.productImage[0].src : ""), placeholderImage: UIImage(named: "tim3"))
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.48, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.04 * collectionView.frame.width
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let drink = self.drinks[collectionView.tag][indexPath.row]
        let vc = DrinkDetailViewController(nibName: "DrinkDetailViewController", bundle: nil)
        vc.drinkDetail = drink
        Utils.setAnimation(view: self.view)
        vc.modalPresentationStyle = .overCurrentContext
        vc.view.backgroundColor = UIColor.clear
        vc.fruitImage = drink.productImage.count > 0 ? drink.productImage[0].src : "notimage"
        vc.fruitName = drink.productTitle
        vc.price = "\(Utils.formmatCurrentcy(fommater: "", price: drink.productVariants.price as NSNumber) )"
        UIView.animate(withDuration: 1.5, animations: {
            self.present(vc, animated: false, completion: nil)
        })
    }
    
}
extension DrinkViewController {
    func loadDrink()  {
        SKActivityIndicator.show("Loding...", userInteractionStatus: false)
        firstly {
            Alamofire.request(url, method: .get, headers: headers).responseDecodable(ProductList.self)
        }.done { products in
            Utils.settingShowDataForDrinkAndFruit(dataService: products.products, drinkOrFruit: &self.drinks, table: self.drinkTableView)
        }.ensure {
            self.drinkTableView.reloadData()
            SKActivityIndicator.dismiss()
            
        }.catch { error in
            Utils.warning(title: "Warning", message: "Data error", addActionOk: true, addActionCancel: false)
        }
    }
}


