//
//  MyComborViewController.swift
//  Mobifood
//
//  Created by Duy Tuan on 6/8/18.
//  Copyright © 2018 Duy Tuan. All rights reserved.
//

import UIKit

class MyComborViewController: UIViewController {

    @IBOutlet weak var headerMyCombor: UIView!
    @IBOutlet weak var myComborTableView: UITableView!
    static var myCombor: [MyCombor] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cartCell = UINib(nibName: "MyComborTableViewCell", bundle: nil)
        self.myComborTableView.register(cartCell, forCellReuseIdentifier: "myCombor")
    }
    
    override func viewDidLayoutSubviews() {
        Utils.setHeader(view: self.headerMyCombor)
    }
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension MyComborViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MyComborViewController.myCombor.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCombor", for: indexPath) as! MyComborTableViewCell
        let combor = MyComborViewController.myCombor[indexPath.row]
        cell.delegate = self
        cell.lblComborName.text = combor.name
        cell.lblComborPrice.text = combor.price
        cell.btnBook.tag = indexPath.row
        cell.myComborImage.sd_setImage(with: URL(string: combor.image!))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.selectionStyle = .none
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIScreen.main.bounds.height < 667 {
            return 0.32 * UIScreen.main.bounds.height
        }
        return 0.25 * UIScreen.main.bounds.height
    }
}

extension MyComborViewController: BuyCombor {
    func buy(index: Int) {
        let myCombor = ComborDetailViewController(nibName: "ComborDetailViewController", bundle: nil)
        myCombor.comborDetail = MyComborViewController.myCombor[index]
        self.present(myCombor, animated: true, completion: nil)
    }
}
