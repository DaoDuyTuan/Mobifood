//
//  ComborViewController.swift
//  Mobifood
//
//  Created by Duy Tuan on 6/4/18.
//  Copyright © 2018 Duy Tuan. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import PromiseKit
import Alamofire
import SKActivityIndicatorView
import SDWebImage

class ComborViewController: UIViewController, IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(image: UIImage(named: "ic_discount"))
    }
    
    @IBOutlet weak var slideCollectionView: UICollectionView!
    var combors = [Product]()
    
    fileprivate var pageSize: CGSize {
        let layout = self.slideCollectionView.collectionViewLayout as! CarouselFlowLayout
        var pageSize = layout.itemSize
        if layout.scrollDirection == .horizontal {
            pageSize.width += layout.minimumLineSpacing
        } else {
            pageSize.height += layout.minimumLineSpacing
        }
        return pageSize
    }
    
    fileprivate var currentPage: Int = 0 {
        didSet (value) {
            currentPage = value
        }
    }
    
    override func viewDidLoad() {
        NetworkManager.whenNoConnection()
        NetworkManager.whenConnected()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadPageWhenNetworkChange), name: .combor, object: nil)
        
        let nib = UINib(nibName: "ComborCollectionViewCell", bundle: nil)
        self.slideCollectionView.register(nib, forCellWithReuseIdentifier: "slideCell")
        self.settingWidthAndHeightForView()
        self.loadCombor()
    }
    
    @objc func reloadPageWhenNetworkChange(notification: NSNotification) {
        self.loadCombor()
    }
    
    private func settingWidthAndHeightForView() {
        let layout = CarouselFlowLayout()
        
        self.setSizeForLayout(layout: layout)
        layout.scrollDirection = .horizontal
        layout.sideItemScale = 0.8
        layout.sideItemAlpha = 1.0
        layout.spacingMode = .fixed(spacing: 10.0)
        self.slideCollectionView.collectionViewLayout = layout
        
        self.slideCollectionView.delegate = self
        self.slideCollectionView.dataSource = self
    }
    
    private func setSizeForLayout(layout: CarouselFlowLayout) {
        let screen = (width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        if screen.height >= 667 {
            if screen.height > 1000 {
                self.slideCollectionView.frame.size = CGSize(width: screen.width * 0.68, height: screen.height * 0.72)
            }
            
            layout.itemSize = CGSize(width: screen.width * 0.6, height: self.slideCollectionView.frame.height * 0.9)
        } else {
            layout.itemSize = CGSize(width: screen.width * 0.68, height: 0.75 * self.slideCollectionView.frame.height)
        }
    }
}

extension ComborViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return combors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "slideCell", for: indexPath) as! ComborCollectionViewCell
        let combor = self.combors[indexPath.row]
        cell.comborImageView.sd_setImage(with: URL(string:
            combor.productImage.count > 0 ? combor.productImage[0].src : ""), placeholderImage: Utils.loadingImage)
        cell.btnBuyItem.setTitle(combor.productTitle, for: .normal)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let comborDetailVC = ComborDynamicViewController(nibName: "ComborDynamicViewController", bundle: nil)
        let drink = self.combors[indexPath.row]
        comborDetailVC.combor.name = drink.productTitle
        comborDetailVC.combor.price = drink.productPrice.isString
        comborDetailVC.combor.image = drink.productImage.count > 0 ? drink.productImage[0].src : nil
        comborDetailVC.combor.idCombor = "\(drink.productID ?? 0)"
        self.present(comborDetailVC, animated: true, completion: nil)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let layout = self.slideCollectionView.collectionViewLayout as! CarouselFlowLayout
        let pageSide = (layout.scrollDirection == .horizontal) ? self.pageSize.width : self.pageSize.height
        let offset = (layout.scrollDirection == .horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
        currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
    }
}

extension ComborViewController {
    private func loadCombor()  {
        self.combors = [Product]()
        let paramsCombor = ["collection_id" : "1001307930"]
        LoadingIndicator.show("Loading...", userInteractionStatus: false)
        
        firstly {
            Alamofire.request(url, method: .get,parameters: paramsCombor, headers: headers).responseDecodable(ProductList.self)
            }.done { products in
                self.combors = products.products
            }.ensure {
                self.slideCollectionView.reloadData()
                self.slideCollectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: .centeredHorizontally, animated: false)
                LoadingIndicator.dismiss()
            }.catch { error in
                Utils.warning(title: "Thông báo", message: "Lỗi dữ liệu", addActionOk: true, addActionCancel: false)
        }
    }
}

extension Notification.Name {
    static let combor = Notification.Name("combor")
    static let fruit = Notification.Name("fruit")
    static let drink = Notification.Name("drink")
}
