//
//  ComborDynamicViewController.swift
//  Mobifood
//
//  Created by Duy Tuan on 6/7/18.
//  Copyright © 2018 Duy Tuan. All rights reserved.
//

import UIKit
import Alamofire
import PromiseKit
import SKActivityIndicatorView

class ComborDynamicViewController: UIViewController {

    @IBOutlet weak var listComborCollectionView: UICollectionView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var lblComborName: UILabel!
    @IBOutlet weak var listSelectedCombor: UITableView!
    @IBOutlet weak var btnExtends: UIButton!
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var myViewConstrainHeight: NSLayoutConstraint!
    @IBOutlet weak var lblIsSetelected: UILabel!
    
    var combor = MyCombor()
    private var drinks = [Product]()
    private var itemsSeleted = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblIsSetelected.isHidden = false
        self.settingUI()
        self.loadDrink()
        
        if self.checkComborDidSelected() {
            self.lblIsSetelected.isHidden = true
           Utils.alert(title: "Thông báo", message: "Bạn đã thêm combor nay rồi", addActionOk: true, addActionCancel: false, vc: self)
            let index = self.getIndexOfComborAdded(combor: self.combor)
            if let indexOf = index {
                self.itemsSeleted = MyComborViewController.myCombor[indexOf].items
                self.listSelectedCombor.reloadData()
            }
        }
    }

    override func viewDidLayoutSubviews() {
        self.autoLayoutUI()
    }
    @IBAction func extends(_ sender: Any) {
        if self.itemsSeleted.count > 0 {
            self.combor.items = self.itemsSeleted
            
            if !self.checkComborDidSelected() {
                MyComborViewController.myCombor.append(self.combor)
            } else {
                let index = self.getIndexOfComborAdded(combor: self.combor)
                if let index = index?.byteSwapped {
                    MyComborViewController.myCombor[index].items = self.itemsSeleted
                }
            }
            let _ = MyAlert().showAlert("Thêm thành công!", subTitle: "Đã thêm vào combor của bạn !", style: AlertStyle.success)
        } else {
            Utils.alert(title: "Thông báo", message: "Bạn chưa chọn nước ép!", addActionOk: true, addActionCancel: false, vc: self)
        }
    }
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ComborDynamicViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemsSeleted.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ComborDetailCell", for: indexPath) as! ComborDetailCellTableViewCell
        let drink = self.itemsSeleted[indexPath.row]
        cell.lblComborName.text = drink.productTitle
        cell.lblComborType.text = "Drink \(indexPath.row + 1)"
        cell.delegate = self
        cell.btnDelete.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0.16 * tableView.frame.height
    }
}

extension ComborDynamicViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.drinks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "comborNameCell" , for: indexPath) as! ComborNameCollectionViewCell
        let drink = self.drinks[indexPath.row]
        cell.lblComborName.text = drink.productTitle
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let drink = self.drinks[indexPath.row]
        self.lblIsSetelected.isHidden = true
        if self.itemsSeleted.filter({$0.productID == drink.productID}).count > 0 {
            Utils.alert(title: "Thông báo", message: "Bạn đã chọn nước ép này rồi", addActionOk: true, addActionCancel: false, vc: self)
        } else {
            self.itemsSeleted.append(drink)
        }
        self.listSelectedCombor.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width * 0.25)
        return CGSize(width: width, height: collectionView.frame.height * 0.2)
    }
}

extension ComborDynamicViewController {
    func updateCombor() {
        
    }
    
    private func settingUI() {
        self.posterImageView.sd_setImage(with: URL(string: combor.image!), placeholderImage: UIImage(named: "loading"))
        self.lblComborName.text = combor.name
        
        let nibCell = UINib(nibName: "ComborDetailCellTableViewCell", bundle: nil)
        self.listSelectedCombor.register(nibCell, forCellReuseIdentifier: "ComborDetailCell")
        
        let nibCombor = UINib(nibName: "ComborNameCollectionViewCell", bundle: nil)
        self.listComborCollectionView.register(nibCombor, forCellWithReuseIdentifier: "comborNameCell")
        
        Utils.setBorder(table: self.listSelectedCombor, width: 1, radius: 10.0, color: UIColor.myColor)
        Utils.setBorder(table: self.listComborCollectionView, width: 1, radius: 10.0, color: UIColor.myColor)
        self.btnExtends.layer.cornerRadius = 20.0
        self.btnExtends.layer.masksToBounds = true
    }
    
    private func loadDrink()  {
        self.drinks = [Product]()
        let paramsDrink = ["collection_id" : "1001165720"]
        LoadingIndicator.show("Loading...", userInteractionStatus: false)
        firstly {
            Alamofire.request(url, method: .get,parameters: paramsDrink, headers: headers).responseDecodable(ProductList.self)
            }.done { products in
                self.drinks = products.products
            }.ensure {
                self.listComborCollectionView.reloadData()
                LoadingIndicator.dismiss()
            }.catch { error in
                Utils.alert(title: "Thông báo", message: "Lỗi dữ liệu", addActionOk: true, addActionCancel: false, vc: self)
        }
    }
    
    private func autoLayoutUI() {
        let heightScreen = UIScreen.main.bounds.height
        if heightScreen > 1300 {
            self.myViewConstrainHeight.constant = 1750
        } else if heightScreen > 1000 && heightScreen < 1300 {
            self.myViewConstrainHeight.constant = 1350
        } else if heightScreen < 667 {
            self.myViewConstrainHeight.constant = 850
        } else if heightScreen > 667 && heightScreen < 1000 {
            self.myViewConstrainHeight.constant = 1050
        }
    }
    
    private func checkComborDidSelected() -> Bool {
        if MyComborViewController.myCombor.filter({$0.idCombor == combor.idCombor}).count > 0 {
            return true
        }
        return false
    }
    
    private func getIndexOfComborAdded(combor: MyCombor) -> Int? {
        let indexOf = MyComborViewController.myCombor.index(where: {
            $0.idCombor == combor.idCombor
        })
        
        guard let index = indexOf?.byteSwapped else {
            return nil
        }
        return index
    }
}

extension ComborDynamicViewController: DeleteDrinkInCombor {
    func deleteDrink(index: Int) {
        self.itemsSeleted.remove(at: index)
        if self.itemsSeleted.count == 0 {
            self.lblIsSetelected.isHidden = false
        }
        self.listSelectedCombor.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        self.listSelectedCombor.reloadData()
    }
}
