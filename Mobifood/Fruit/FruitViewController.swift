//
//  FruitViewController.swift
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

class FruitViewController: UIViewController, IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(image: UIImage(named: "ic_fruit"))
    }
    fileprivate var refreshTable: UIRefreshControl!
    
    
    @IBOutlet weak var fruitCollectionView: UICollectionView!
    var fruits = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshTable = Utils.MyRefreshControl
        self.refreshTable.addTarget(self, action: #selector(conrolRefresh), for: .valueChanged)
        self.fruitCollectionView.addSubview(self.refreshTable)
        
        let nib = UINib(nibName: "DrinkCollectionViewCell", bundle: nil)
        self.fruitCollectionView.register(nib, forCellWithReuseIdentifier: "drinkCollectionCell")
        NotificationCenter.default.addObserver(self, selector: #selector(reloadPageWhenNetworkChange), name: .fruit, object: nil)
        self.createLayoutForCollectionView()
        self.checkNetworkState()
    }
    
    @objc func conrolRefresh() {
        self.refreshTable.endRefreshing()
    }
    
    @objc func reloadPageWhenNetworkChange(notification: NSNotification) {
        Utils.warning(title: "Success", message: "Connected Internet", addActionOk: true, addActionCancel: false)
        self.loadFruit()
    }
}

extension FruitViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.fruits.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "drinkCollectionCell" , for: indexPath) as! DrinkCollectionViewCell
        let fruit = self.fruits[indexPath.row]
        cell.lblNameFruit.text = fruit.productTitle
        cell.lblPriceFruit.text = "\(Utils.formmatCurrentcy(fommater: "", price: fruit.productVariants.price as NSNumber) )"
        cell.imageFruitImageView.sd_setImage(with: URL(string:
                fruit.productImage.count > 0 ? fruit.productImage[0].src : ""), placeholderImage: Utils.loadingImage)
        cell.lblSize.isHidden = true
        cell.lblSizeType.isHidden = true
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.width / 2) - 15
        
        return CGSize(width: width, height: self.view.frame.height * 0.47)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DrinkDetailViewController(nibName: "DrinkDetailViewController", bundle: nil)
        Utils.setAnimation(view: self.view)
        vc.modalPresentationStyle = .overCurrentContext
        vc.view.backgroundColor = UIColor.clear
        let fruit = self.fruits[indexPath.row]
        vc.drinkDetail = fruit
        vc.fruitImage = fruit.productImage.count > 0 ? fruit.productImage[0].src : "notimage"
        vc.fruitName = fruit.productTitle
        vc.price = "\(Utils.formmatCurrentcy(fommater: "", price: fruit.productVariants.price as NSNumber) )"
        UIView.animate(withDuration: 1.5, animations: {
            self.present(vc, animated: false, completion: nil)
        })
    }
}
extension FruitViewController {
    private func loadFruit() {
        self.fruits = [Product]()
        let paramsFruit = ["collection_id": "1001103057"]
        if !self.refreshTable.isRefreshing {
            LoadingIndicator.show("Loading...", userInteractionStatus: false)
        }
        firstly {
            Alamofire.request(url, method: .get, parameters: paramsFruit, headers: headers).responseDecodable(ProductList.self)
            }.done { products in
                self.fruits = products.products
            }.ensure {
                self.fruitCollectionView.reloadData()
                LoadingIndicator.dismiss()
            }.catch { error in
                print(error)
                Utils.warning(title: "Thông báo", message: "Lỗi dữ liệu", addActionOk: true, addActionCancel: false)
        }
    }
    
    private func createLayoutForCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.fruitCollectionView.collectionViewLayout = layout
    }
    private func checkNetworkState() {
        NetworkManager.whenNoConnection()
        NetworkManager.whenConnected()
        NetworkManager.isReachable(completed: {_ in
            self.loadFruit()
        })
    }
}
