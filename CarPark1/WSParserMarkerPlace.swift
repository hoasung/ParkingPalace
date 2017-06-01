//
//  WSDict.swift
//  Crossword
//
//  Created by thonv on 04/20/17.
//  Copyright © 2017 Viettel. All rights reserved.
//

import UIKit
import GoogleMaps

class WSParserMarkerPlace: NSObject, XMLParserDelegate {
    
    static let me:WSParserMarkerPlace=WSParserMarkerPlace()
    var mPlaces : [MarkerPlace] = []
    enum State { case none, name, lat, long1, capacity, remain, idParkingLocation }
    var state: State = .none
    var newPlace: MarkerPlace? = nil
    var nearestPlace: MarkerPlace? = nil
    var nearestDistance: Double = DBL_MAX
    var mMyLocation : CLLocationCoordinate2D? = nil
    
//    let webSearch = "http://42.112.16.180:9898/EnglishDics/webresources/model.detail/"
    let webSearch = "http://42.112.16.180:9898/EnglishDics/webresources/model.parkinglocation"
    func doSearch(myLocation: CLLocationCoordinate2D){
        mPlaces.removeAll()
        self.mMyLocation = myLocation
        let url = URL(string: webSearch)
        
        let parser = XMLParser(contentsOf: url!)
        
        parser?.delegate = self
        parser?.parse()
        
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        guard let _ = self.newPlace else { return }
        switch self.state {
        
        case .capacity:
            self.newPlace?.capacity = Int(string)!
        case .idParkingLocation:
            self.newPlace?.idParkingLocation = Int(string)!
        case .lat:
            self.newPlace?.lat = Double(string)!
        case .long1:
            self.newPlace?.long1 = Double(string)!
        case .name:
            self.newPlace?.placeName = string
        case .remain:
            self.newPlace?.remain = Int(string)!
        default:
            self.state = .none
        }
        
    }
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        switch elementName {
        case "parkingLocation" :
            self.newPlace = MarkerPlace()
            self.state = .none
        case "capacity":
            self.state = .capacity
        case "idParkingLocation":
            self.state = .idParkingLocation
        case "lat":
            self.state = .lat
        case "long1":
            self.state = .long1
        case "name":
            self.state = .name
        case "remain":
            self.state = .remain
        default:
            self.state = .none
        }
        
        
    }
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if let newPlace = self.newPlace, elementName == "parkingLocation" {
            let distance = Utils.me.distance(x1: (mMyLocation?.latitude)!, y1: (mMyLocation?.longitude)!, x2: newPlace.lat, y2: newPlace.long1)
            if distance < nearestDistance {
                nearestPlace = newPlace
                nearestDistance = distance
            }
            self.mPlaces.append(newPlace)
            self.newPlace = nil
        }
        self.state = .none
    }
}
