//
//  AppDelegate.swift
//  Mobifood
//
//  Created by Duy Tuan on 6/4/18.
//  Copyright © 2018 Duy Tuan. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey("AIzaSyCxeD0qlWHnOIKbEDcsYoq_st1JBSwSJSg")
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let userDefault = UserDefaults.standard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let _ = userDefault.object(forKey: "isLauched") as? String {
            let vc = storyboard.instantiateViewController(withIdentifier: "root")
            self.window?.rootViewController = UINavigationController(rootViewController: vc)
        } else {
            userDefault.set("OK", forKey: "isLauched")
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "introduceVC")
            self.window?.rootViewController = initialViewController
        }
        
        for combor in ManagerLocalData.shareData.fetchDataFromLocal(entity: "MyCombors") {
            let idCombor1 = combor.value(forKey: "idCombor") as! String
            let name = combor.value(forKey: "name") as? String
            let price = combor.value(forKey: "price") as? String
            let image = combor.value(forKey: "image") as? String
            var myCombor = MyCombor(id: idCombor1, name: name, price: price, image: image)
            for product in ManagerLocalData.shareData.fetchDataFromLocal(entity: "Products") {
                let item = ManagerLocalData.shareData.initDataWhenOpenApp(product: product)
                
                if idCombor1 == item.idCombor {
                    myCombor.items.append(item)
                }
            }
            MyComborViewController.myCombor.append(myCombor)
        }
    
        for product in ManagerLocalData.shareData.fetchDataFromLocal(entity: "Products") {
            let item = ManagerLocalData.shareData.initDataWhenOpenApp(product: product)
            if item.idCombor == "" {
                CartViewController.cart.append(item)
            }
        }
        self.window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "Product")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

