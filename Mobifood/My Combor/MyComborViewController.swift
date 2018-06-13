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
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCombor", for: indexPath) as! MyComborTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.selectionStyle = .none
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0.25 * UIScreen.main.bounds.height
    }
}
