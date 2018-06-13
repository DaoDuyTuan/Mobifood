//
//  ComborViewController.swift
//  Mobifood
//
//  Created by Duy Tuan on 6/4/18.
//  Copyright © 2018 Duy Tuan. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class ComborViewController: UIViewController, IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(image: UIImage(named: "ic_discount"))
    }
    
    @IBOutlet weak var slideCollectionView: UICollectionView!
    
    fileprivate var pageSize: CGSize {
        let layout = self.slideCollectionView.collectionViewLayout as! UPCarouselFlowLayout
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
    
    let images = ["red2", "red2", "red2", "red2", "red2"]
    override func viewDidLoad() {
        NetworkManager.whenNoConnection()
        NetworkManager.sharedInstance.reachability.whenReachable = {_ in
            Utils.warning(title: "Success", message: "Connected Internet", addActionOk: true, addActionCancel: false)
        }
        
        let nib = UINib(nibName: "ComborCollectionViewCell", bundle: nil)
        self.slideCollectionView.register(nib, forCellWithReuseIdentifier: "slideCell")
        
        let layout = UPCarouselFlowLayout()
        if UIScreen.main.bounds.height >= 667 {
            layout.itemSize = CGSize(width: self.view.frame.width * 0.68, height: self.slideCollectionView.frame.size.height)
        } else {
            layout.itemSize = CGSize(width: self.view.frame.width - 0.42 * self.view.frame.width, height: 0.8 * self.slideCollectionView.frame.size.height)
        }
        
        layout.scrollDirection = .horizontal
        layout.sideItemScale = 0.8
        layout.sideItemAlpha = 1.0
        layout.spacingMode = .fixed(spacing: 10.0)
        self.slideCollectionView.collectionViewLayout = layout
        
        self.slideCollectionView.delegate = self
        self.slideCollectionView.dataSource = self
        
        self.slideCollectionView.scrollToItem(at: IndexPath(row: 2, section: 0), at: .centeredHorizontally, animated: true)
    }
}

extension ComborViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "slideCell", for: indexPath) as! ComborCollectionViewCell
        cell.comborImageView.image = UIImage(named: images[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let comborDetailVC = ComborDynamicViewController(nibName: "ComborDynamicViewController", bundle: nil)
        self.navigationController?.pushViewController(comborDetailVC, animated: true)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let layout = self.slideCollectionView.collectionViewLayout as! UPCarouselFlowLayout
        let pageSide = (layout.scrollDirection == .horizontal) ? self.pageSize.width : self.pageSize.height
        let offset = (layout.scrollDirection == .horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
        currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
    }
}

