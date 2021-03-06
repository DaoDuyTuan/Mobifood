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
    
    @IBOutlet weak var drinkCollectionView: UICollectionView!
    fileprivate var isScrollDelecrateAtTop = false
    fileprivate var refreshTable: UIRefreshControl!
    var drinks = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshTable = Utils.MyRefreshControl
        self.refreshTable.addTarget(self, action: #selector(conrolRefresh), for: .valueChanged)
        self.drinkCollectionView.addSubview(self.refreshTable)
        
        let nib = UINib(nibName: "DrinkCollectionViewCell", bundle: nil)
        self.drinkCollectionView.register(nib, forCellWithReuseIdentifier: "drinkCollectionCell")
        NotificationCenter.default.addObserver(self, selector: #selector(reloadPageWhenNetworkChange), name: .drink, object: nil)
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.drinkCollectionView.collectionViewLayout = layout
        
        self.checkNetworkState()
    }
    
    @objc func conrolRefresh() {
        self.refreshTable.endRefreshing()
    }
    
    @objc func reloadPageWhenNetworkChange(notification: NSNotification) {
        Utils.warning(title: "Success", message: "Connected Internet", addActionOk: true, addActionCancel: false)
        self.loadDrink()
    }
}

extension DrinkViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.drinks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "drinkCollectionCell" , for: indexPath) as! DrinkCollectionViewCell
        let drink = self.drinks[indexPath.row]
        cell.lblNameFruit.text = drink.productTitle
            cell.lblPriceFruit.text = "\(drink.productVariants.price)"
        
        cell.lblPriceFruit.text = "\(Utils.formmatCurrentcy(fommater: "", price: drink.productVariants.price as NSNumber) )"
        cell.imageFruitImageView.sd_setImage(with: URL(string:
            drink.productImage.count > 0 ? drink.productImage[0].src : ""), placeholderImage: UIImage(named: "loading"))
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.width / 2) - 15
        if Utils.heightScreen < 667 {
            return CGSize(width: width, height: self.view.frame.height * 0.50)
        }
        return CGSize(width: width, height: self.view.frame.height * 0.48)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let drink = self.drinks[indexPath.row]
        let vc = DrinkDetailViewController(nibName: "DrinkDetailViewController", bundle: nil)
        vc.drinkDetail = drink
        DrinkDetailModelView.drinkDetailModelView.setViewWillShow(vc: vc)
        DrinkDetailModelView.drinkDetailModelView.setDataForDrinkDetail(vc: vc, with: drink)
        Utils.setAnimation(view: self.view)
        UIView.animate(withDuration: 1.5, animations: {
            self.present(vc, animated: false, completion: nil)
        })
    }
}

extension DrinkViewController {
    private func loadDrink()  {
        self.drinks = [Product]()
        let paramsDrink = ["collection_id" : "1001165720"]
        LoadingIndicator.show("Loading...", userInteractionStatus: false)
        firstly {
            Alamofire.request(url, method: .get,parameters: paramsDrink, headers: headers).responseDecodable(ProductList.self)
        }.done { products in
            self.drinks = products.products
        }.ensure {
            self.drinkCollectionView.reloadData()
            LoadingIndicator.dismiss()
        }.catch { error in
            Utils.warning(title: "Thông báo", message: "Lỗi dữ liệu", addActionOk: true, addActionCancel: false)
        }
    }
    
    private func checkNetworkState() {
        NetworkManager.whenNoConnection()
        NetworkManager.whenConnected()
        NetworkManager.isReachable(completed: {_ in
            self.loadDrink()
        })
    }
}


