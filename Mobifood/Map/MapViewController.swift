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
    private var userLocation: CLLocation?
    private var listLocation = [CLLocation]()
    @IBOutlet weak  var mapView: GMSMapView!
    @IBOutlet weak var activityLoading: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkManager.whenNoConnection()
        SKActivityIndicator.show("Loading")
        self.mapView.isMyLocationEnabled = true
        self.mapView.settings.myLocationButton = true
        self.mapView.settings.zoomGestures = true
        self.mapView.settings.compassButton = true
        self.mapView.settings.indoorPicker = true
        self.currentLocation()
    }
    
    func currentLocation() {
        firstly {
            CLLocationManager.promise()
            }.done { locations in
                if let location = locations.first {
                    let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 13.0)
                    self.mapView.camera = camera
                    self.userLocation = location
                }
            }.then { _ in
                when(fulfilled: CLGeocoder().reverseGeocode(location: self.userLocation!), CLGeocoder().reverseGeocode(location: CLLocation(latitude: 20.996461, longitude: 105.82665799999995)))
            }.done { placemark1, placemark2 in
                let places = [placemark2]
                self.listLocation.append(CLLocation(latitude: 20.996461, longitude: 105.82665799999995))
                
                for (index, value) in self.listLocation.enumerated() {
                    self.reverseLocationToMarker(placemarksArray: places[index], location: value)
                }
            }.ensure {
                SKActivityIndicator.dismiss()
            }.catch { error in
                SKActivityIndicator.dismiss()
                Utils.warning(title: "Thông báo", message: "Lỗi vị trí", addActionOk: true, addActionCancel: false)
        }
    }
    
    private func reverseLocationToMarker(placemarksArray: [CLPlacemark], location: CLLocation) {
        if (placemarksArray.count) > 0 {
            let placemark = placemarksArray.first
            let number = placemark!.subThoroughfare
            let bairro = placemark!.subLocality
            let street = placemark!.thoroughfare
            let locality = placemark!.locality
            
            let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: (location.coordinate.latitude) , longitude: (location.coordinate.longitude)))
            marker.title = street ?? ""
            marker.snippet = "\(number ?? ""), \(street ?? ""), \(bairro ?? ""), \(locality ?? "")"
            marker.map = self.mapView
        }
    }
}
