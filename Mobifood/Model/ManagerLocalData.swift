//
//  ManagerLocalData.swift
//  Mobifood
//
//  Created by Duy Tuan on 7/4/18.
//  Copyright © 2018 Duy Tuan. All rights reserved.
//

import UIKit
import CoreData

class ManagerLocalData: NSObject {
    static var shareData = ManagerLocalData()
    
    func saveProduct(product: Product) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Products", in: managedContext)
        
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        person.setValue(product.productID, forKey: "id")
        person.setValue(product.productTitle, forKey: "title")
        person.setValue(product.amount, forKey: "amount")
        person.setValue(product.productImage[0].src, forKey: "images")
        person.setValue(product.productVariants.price, forKey: "variants")
        person.setValue(product.isCheckedProduct, forKey: "isChecked")
        
        do{
            try managedContext.save()
        }catch let error as NSError{
            print("Could not save - " + "\(error.userInfo)" )
        }
    }
    
    func saveCombor(mycombor: MyCombor) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "MyCombors", in: managedContext)
        
        let combor = NSManagedObject(entity: entity!, insertInto: managedContext)
        combor.setValue(mycombor.name, forKey: "name")
        combor.setValue(mycombor.price, forKey: "price")
        combor.setValue(mycombor.image, forKey: "image")
        combor.setValue(mycombor.date, forKey: "date")
        combor.setValue(mycombor.idCombor, forKey: "idCombor")
        
        do{
            try managedContext.save()
        }catch let error as NSError{
            print("Could not save - " + "\(error.userInfo)" )
        }
    }
    
    func fetchDataFromLocal(entity: String) -> [NSManagedObject] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchData = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        
        var products = [NSManagedObject]()
        do{
            try products = managedContext.fetch(fetchData) as! [NSManagedObject]
        }catch let error as NSError{
            print(error)
        }
        return products
    }
    
    func json(from object: Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    func updateData(productWillUpdate: Product) {
        for (index, product) in self.fetchDataFromLocal(entity: "Products").enumerated() {
            if let pr = product.value(forKey: "id") as? Double {
                if productWillUpdate.productID == pr {
                    self.fetchDataFromLocal(entity: "Products")[index].setValue(productWillUpdate.amount, forKey: "amount")
                }
            }
        }
    }
    
    func deleteData(productWillDelete: Product) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        for (index, product) in self.fetchDataFromLocal(entity: "Products").enumerated() {
            if let id = product.value(forKey: "id") as? Double {
                if productWillDelete.productID == id {
                    managedContext.delete(self.fetchDataFromLocal(entity: "Products")[index])
                }
            }
        }
        
        do {
            try managedContext.save()
        } catch let err as NSError{
            print(err)
        }

    }
}
