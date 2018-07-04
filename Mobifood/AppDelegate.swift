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
        
        for product in ManagerLocalData.shareData.fetchDataFromLocal(entity: "Products") {
            let id = product.value(forKey: "id") as! Double
            let title = product.value(forKey: "title") as! String
            let image = Image(src: "\(product.value(forKey: "images") as? String ?? "notimage")")
            let variants = Variant(price: product.value(forKey: "variants") as! Int)
            let isChecked = product.value(forKey: "isChecked") as! Bool
            let amount = product.value(forKey: "amount") as! Int
            let item = Product(id: id,
                               title: title,
                               variants: [variants],
                               images: [image],
                               amount: amount,
                               isChecked: isChecked)
            CartViewController.cart.append(item)
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

