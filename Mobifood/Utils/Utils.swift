//
//  Utils.swift
//  Mobifood
//
//  Created by Duy Tuan on 6/4/18.
//  Copyright © 2018 Duy Tuan. All rights reserved.
//

import Foundation
import UIKit

class Utils: NSObject {
    static func showIndicator(indicator: UIActivityIndicatorView) {
        indicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    static func hideIndicator(indicator: UIActivityIndicatorView) {
        indicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    static func setAnimation(view: UIView) {
        
        CATransaction.begin()
        let transition: CATransition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFade
        view.window!.layer.add(transition, forKey: nil)
        CATransaction.commit()
    }

    static func setBorder(table: UIView, width: CGFloat, radius: CGFloat, color: UIColor) {
        table.layer.cornerRadius = radius
        table.layer.borderWidth = width
        table.layer.borderColor = color.cgColor
        table.layer.masksToBounds = true
    }
    static func setHeader(view: UIView) {
        // custom header color background
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor(displayP3Red: 0/255, green: 174/255, blue: 236/255, alpha: 1).cgColor, UIColor(displayP3Red: 3/255, green: 166/255, blue: 131/255, alpha: 1).cgColor]
        view.layer.insertSublayer(gradient, at: 0)
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
    }

    static func animateOut(view: UIView) {
        UIView.animate(withDuration: 0.2, animations: {
            view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            view.alpha = 0
        }) { (success: Bool) in
            view.removeFromSuperview()
        }
    }

    static func warning(title: String, message: String, addActionOk: Bool, addActionCancel: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if addActionOk {
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {alert in
                if let topController = UIApplication.shared.keyWindow?.rootViewController {
                    topController.dismiss(animated: true, completion: nil)
                }
            }))
        }
        if addActionCancel {
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        }
        if let topController = UIApplication.shared.keyWindow?.rootViewController {
            topController.present(alert, animated: true, completion: nil)
        }
    }
    static func alert(title: String, message: String, addActionOk: Bool, addActionCancel: Bool, vc: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if addActionOk {
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {alert in
                Utils.setAnimation(view: vc.view)
                vc.dismiss(animated: true, completion: nil)
            }))
        }
        if addActionCancel {
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        }
        vc.present(alert, animated: true, completion: nil)
    }

    static func animateIn(view: UIView) {
        view.alpha = 1
        view.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        UIView.animate(withDuration: 0.2, animations: {
            view.transform = .identity
        })
    }

    static func formmatCurrentcy(fommater: String, price: NSNumber) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        formatter.locale = Locale(identifier: "vi-VN")
        return formatter.string(from: price) ?? "Invalid"
    }
    
    static func settingShowDataForDrinkAndFruit(dataService: [Product], drinkOrFruit: inout [[Product]], table: UITableView) {
        if dataService.count % 2 == 0 {
            var count = 0
            while drinkOrFruit.count != dataService.count / 2 {
                var productList = [Product]()
                for _ in 0...1 {
                    productList.append(dataService[count])
                    count += 1
                }
                drinkOrFruit.append(productList)
            }
        } else {
            var count = 0
            while drinkOrFruit.count != dataService.count - 1 {
                var productList = [Product]()
                for _ in 0...1 {
                    productList.append(dataService[count])
                    count += 1
                }
                drinkOrFruit.append(productList)
            }
            drinkOrFruit.append([dataService[count + 1]])
        }

    }
    
    static var loadingImage: UIImage {
        let img = UIImageView(image: UIImage(named: "loading"))
        img.contentMode = .scaleAspectFit
        return img.image!
    }
}

extension UIColor {
    static var myColor: UIColor {
        return UIColor(displayP3Red: 184/255, green: 184/255, blue: 184/255, alpha: 1)
    }
    static var myGreen: UIColor {
        return UIColor(displayP3Red: 129/255, green: 242/255, blue: 134/255, alpha: 1)
    }
}

extension Array where Element: Equatable {
    func indexes(of item: Element) -> [Int]  {
        return enumerated().compactMap { $0.element == item ? $0.offset : nil }
    }
}
