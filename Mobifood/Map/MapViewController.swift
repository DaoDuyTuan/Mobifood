//
//  MapViewController.swift
//  Mobifood
//
//  Created by Duy Tuan on 6/4/18.
//  Copyright © 2018 Duy Tuan. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import GoogleMaps
import CoreLocation
import SKActivityIndicatorView
import PromiseKit
import MapKit

class MapViewController: UIViewController, IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(image: UIImage(named: "ic_place"))
    }
    private var locationManager: CLLocationManager!
    private var location: CLLocation?
    @IBOutlet weak  var mapView: GMSMapView!
    @IBOutlet weak var activityLoading: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkManager.whenNoConnection()
        SKActivityIndicator.show("", userInteractionStatus: false)

        firstly {
            CLLocationManager.promise()
            }.done { location in
                if let location = location.first {
                    let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 16.0)
                    self.mapView.camera = camera
                    self.location = location
                }

            }.then { _ in
                CLGeocoder().reverseGeocode(location: self.location!)
            }.done { placemarksArray in

                if (placemarksArray.count) > 0 {
                    let placemark = placemarksArray.first
                    let number = placemark!.subThoroughfare
                    let bairro = placemark!.subLocality
                    let street = placemark!.thoroughfare
                    let locality = placemark!.locality

                    let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: (self.location?.coordinate.latitude)! , longitude: (self.location?.coordinate.longitude)! ))

                    marker.title = street ?? ""
                    marker.snippet = "\(number ?? ""), \(street ?? ""), \(bairro ?? ""), \(locality ?? "")"
                    marker.map = self.mapView
                }
            }.ensure {
                SKActivityIndicator.dismiss()
            }.catch { error in
                SKActivityIndicator.dismiss()
                Utils.warning(title: "Warning", message: "Location error", addActionOk: true, addActionCancel: false)
        }
    }
}
