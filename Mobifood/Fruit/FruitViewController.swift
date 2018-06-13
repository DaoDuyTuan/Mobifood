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
    @IBOutlet weak var fruitTableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    var fruits = [[Product]]()
    var images: [[UIImageView]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        images = [[UIImageView]]()
        let nibTableViewCell = UINib(nibName: "DrinkTableViewCell", bundle: nil)
        self.fruitTableView.register(nibTableViewCell, forCellReuseIdentifier: "drinkTableCell")
        self.loadingIndicator.hidesWhenStopped = true
        NetworkManager.whenNoConnection()
        NetworkManager.sharedInstance.reachability.whenReachable = {_ in
            Utils.warning(title: "Success", message: "Connected Internet", addActionOk: true, addActionCancel: false)
            self.fruits = [[Product]]()
            self.fruitTableView.reloadData()
            self.loadFruit()
        }
        NetworkManager.isReachable(completed: {_ in
            self.loadFruit()
        })
    }
}

extension FruitViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fruits.count
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

extension FruitViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.fruits[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "drinkCollectionCell" , for: indexPath) as! DrinkCollectionViewCell
        let fruit = self.fruits[collectionView.tag][indexPath.row]
        cell.lblNameFruit.text = fruit.productTitle
        cell.lblPriceFruit.text = "\(Utils.formmatCurrentcy(fommater: "", price: fruit.productVariants.price as NSNumber) )"
//        cell.imageFruitImageView.sd_setImage(with: URL(string:
//                fruit.productImage.count > 0 ? fruit.productImage[0].src : ""), placeholderImage: UIImage(named: "notimage"))
        cell.imageFruitImageView.image = self.images[collectionView.tag][indexPath.row].image
        cell.lblSize.isHidden = true
        cell.lblSizeType.isHidden = true
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width * 0.46, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DrinkDetailViewController(nibName: "DrinkDetailViewController", bundle: nil)
        Utils.setAnimation(view: self.view)
        vc.modalPresentationStyle = .overCurrentContext
        vc.view.backgroundColor = UIColor.clear
        let fruit = self.fruits[collectionView.tag][indexPath.row]
        vc.drinkDetail = fruit
        vc.fruitImage = fruit.productImage.count > 0 ? fruit.productImage[0].src : "red2"
        vc.fruitName = fruit.productTitle
        vc.price = "\(Utils.formmatCurrentcy(fommater: "", price: fruit.productVariants.price as NSNumber) )"
        UIView.animate(withDuration: 1.5, animations: {
            self.present(vc, animated: false, completion: nil)
        })
    }
}
extension FruitViewController {
    func loadFruit()  {
        self.fruits = [[Product]]()
        SKActivityIndicator.show("Loding...", userInteractionStatus: false)
        firstly {
            Alamofire.request(url, method: .get, headers: headers).responseDecodable(ProductList.self)
            }.done { products in
                Utils.settingShowDataForDrinkAndFruit(dataService: products.products, drinkOrFruit: &self.fruits, table: self.fruitTableView)
                for product in self.fruits {
                    var images = [UIImageView]()
                    for pr in product {
                        let img = UIImageView()

                        img.sd_setImage(with: URL(string: pr.productImage.count > 0 ? pr.productImage[0].src : "notimage" ), placeholderImage: UIImage(named: "notimage"))
                        images.append(img)
                    }
                    self.images.append(images)
                }
            }.ensure {
                self.fruitTableView.reloadData()
                SKActivityIndicator.dismiss()
            }.catch { error in
                Utils.warning(title: "Warning", message: "Data error", addActionOk: true, addActionCancel: false)
        }
    }
}
