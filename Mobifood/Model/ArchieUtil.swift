//
//  ArchieUtil.swift
//  Mobifood
//
//  Created by Duy Tuan on 7/2/18.
//  Copyright © 2018 Duy Tuan. All rights reserved.
//

import UIKit

class ArchieUtil: NSObject {
        
    private static let mycart = "mycart"
    
    private static func archivePeople(product : [Person]) -> NSData {
        
        return NSKeyedArchiver.archivedData(withRootObject: product as NSArray) as NSData
    }
    
    static func loadProduct() -> [Person]? {
        
        if let unarchivedObject = UserDefaults.standard.object(forKey: mycart) as? Data {
            
            return NSKeyedUnarchiver.unarchiveObject(with: unarchivedObject as Data) as? [Person]
        }
        
        return nil
    }
    
    static func savePeople(product : [Person]?) {
        
        let archivedObject = archivePeople(product: product!)
        UserDefaults.standard.set(archivedObject, forKey: mycart)
        UserDefaults.standard.synchronize()
    }
}
