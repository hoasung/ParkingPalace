//
//  MyMarker.swift
//  CarPark1
//
//  Created by thonv on 05/19/17.
//  Copyright © 2017 thonv. All rights reserved.
//

import UIKit
import GoogleMaps

class MarkerPlace: GMSMarker {
    var placeName : String
    var placeAddress : String
    var lat : Double
    var long1: Double
    var capacity: Int
    var remain: Int
    var idParkingLocation : Int
    override init() {
        
        
        placeName = ""
        placeAddress = ""
        lat = 0.0
        long1 = 0.0
        capacity = 0
        remain = 0
        idParkingLocation = 0
        super.init()
    }
    convenience init(marker: GMSMarker){
        self.init()
        placeName = marker.title!
        placeAddress = marker.title!
        lat = marker.position.latitude
        long1 = marker.position.longitude
        
        
    }
    convenience init(name: String, addr: String, pos: CLLocation){
        self.init()
        placeName = name
        placeAddress = addr
        lat = pos.coordinate.latitude
        long1 = pos.coordinate.longitude
        
        
    }
    func display(mapView : GMSMapView, isChangeIcon: Bool){
        self.position = CLLocationCoordinate2D(latitude: lat, longitude: long1)
        
        self.map = mapView
        if isChangeIcon {
            self.makeIcon()
        }
    }
    func makeIcon(){
        let DynamicView=UIView(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 30, height: 60)))
        DynamicView.backgroundColor=UIColor.clear
        
        var imageViewForPinMarker : UIImageView
        imageViewForPinMarker  = UIImageView(frame:CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 30, height: 60)))
        imageViewForPinMarker.image = UIImage(named:"parking12_n")
        
        let text = UILabel(frame:CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 30, height: 35)))
        text.text = String(remain)
        text.textColor = UIColor.white
    
        text.font = UIFont.boldSystemFont(ofSize: 20)
        text.textAlignment = .center
        
        //text.sizeToFit()
        
        
        imageViewForPinMarker.addSubview(text)
        DynamicView.addSubview(imageViewForPinMarker)
        
        UIGraphicsBeginImageContextWithOptions(DynamicView.frame.size, false, UIScreen.main.scale)
        DynamicView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let imageConverted: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        self.icon = imageConverted
        //marker.map = self.mapView
    }
    
    
}
