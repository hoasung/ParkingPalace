//
//  MapTasks.swift
//  GMapsDemo
//
//  Created by Gabriel Theodoropoulos on 29/3/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

import UIKit
import GoogleMaps

enum TravelModes: Int {
    case driving
    case walking
    case bicycling
}


class MapTasks: NSObject {
   
    let baseURLGeocode = "https://maps.googleapis.com/maps/api/geocode/json?"
    
    var lookupAddressResults: Dictionary<String, Any>!
    
    var fetchedFormattedAddress: String!
    
    var fetchedAddressLongitude: Double!
    
    var fetchedAddressLatitude: Double!
    
    let baseURLDirections = "https://maps.googleapis.com/maps/api/directions/json?"
    
    var selectedRoute: Dictionary<String, Any>!
    
    var overviewPolyline: Dictionary<String, Any>!
    
    var originCoordinate: CLLocationCoordinate2D!
    
    var destinationCoordinate: CLLocationCoordinate2D!
    
    var originAddress: String!
    
    var destinationAddress: String!
    
    var totalDistanceInMeters: UInt = 0
    
    var totalDistance: String!
    
    var totalDurationInSeconds: UInt = 0
    
    var totalDuration: String!
    
    
    override init() {
        super.init()
    }
    
    
    func geocodeAddress(_ address: String!, withCompletionHandler completionHandler: @escaping ((_ status: String, _ success: Bool) -> Void)) {
        if let lookupAddress = address {
            var geocodeURLString = baseURLGeocode + "address=" + lookupAddress
            geocodeURLString = geocodeURLString.addingPercentEscapes(using: String.Encoding.utf8)!
            
            let geocodeURL = URL(string: geocodeURLString)
            
            DispatchQueue.main.async(execute: { () -> Void in
                let geocodingResultsData = try? Data(contentsOf: geocodeURL!)
                
                var error: NSError?
                var dictionary = Dictionary<String, Any>()
                do{
                    dictionary = try JSONSerialization.jsonObject(with: geocodingResultsData!, options: []) as! Dictionary<String, Any>
                    
                }
                catch{
                    print(error)
                }
                
                if (error != nil) {
                    print(error)
                    completionHandler("", false)
                }
                else {
                    // Get the response status.
                    let status = dictionary["status"] as! String
                    
                    if status == "OK" {
                        let allResults = dictionary["results"] as! Array<Dictionary<String, Any>>
                        self.lookupAddressResults = allResults[0]
                        
                        // Keep the most important values.
                        self.fetchedFormattedAddress = self.lookupAddressResults["formatted_address"] as! String
                        let geometry = self.lookupAddressResults["geometry"] as! Dictionary<String, AnyObject>
                        let tmp = (geometry["location"] as! Dictionary<String, AnyObject>)
                        self.fetchedAddressLongitude = (tmp["lng"] as! NSNumber).doubleValue
                        self.fetchedAddressLatitude = ((geometry["location"] as! Dictionary<String, AnyObject>)["lat"] as! NSNumber).doubleValue
                        
                        completionHandler(status, true)
                    }
                    else {
                        completionHandler(status, false)
                    }
                }
            })
        }
        else {
            completionHandler("No valid address.", false)
        }
    }
    
    
    func getDirections(_ origin: String!, destination: String!, waypoints: Array<String>!, travelMode: TravelModes!, completionHandler: @escaping ((_ status: String, _ success: Bool) -> Void)) {
        
        if let originLocation = origin {
            if let destinationLocation = destination {
                var directionsURLString = baseURLDirections + "origin=" + originLocation + "&destination=" + destinationLocation
                
                if let routeWaypoints = waypoints {
                    directionsURLString += "&waypoints=optimize:true"
                    
                    for waypoint in routeWaypoints {
                        directionsURLString += "|" + waypoint
                    }
                }
                
                if (travelMode) != nil {
                    var travelModeString = ""
                    
                    switch travelMode.rawValue {
                    case TravelModes.walking.rawValue:
                        travelModeString = "walking"
                        
                    case TravelModes.bicycling.rawValue:
                        travelModeString = "bicycling"
                        
                    default:
                        travelModeString = "driving"
                    }
                    
                    
                    directionsURLString += "&mode=" + travelModeString
                }
                
                
                directionsURLString = directionsURLString.addingPercentEscapes(using: String.Encoding.utf8)!
                
                let directionsURL = URL(string: directionsURLString)
                
                DispatchQueue.main.async(execute: { () -> Void in
                    let directionsData = try? Data(contentsOf: directionsURL!)
                    
                    var error: NSError?
                    
                    var dictionary = Dictionary<String, Any>()
                    do{
                        dictionary = try JSONSerialization.jsonObject(with: directionsData!, options: []) as! Dictionary<String, Any>
                        
                    }
                    catch{
                        print(error)
                    }
                    
                    
//                    let dictionary: Dictionary<NSObject, AnyObject> = JSONSerialization.JSONObjectWithData(directionsData!, options: JSONSerialization.ReadingOptions.MutableContainers, error: &error) as Dictionary<NSObject, AnyObject>
                    
                    if (error != nil) {
                        print(error)
                        completionHandler("", false)
                    }
                    else {
                        let status = dictionary["status"] as! String
                        
                        if status == "OK" {
                            self.selectedRoute = (dictionary["routes"] as! Array<Dictionary<String, Any>>)[0]
                            self.overviewPolyline = self.selectedRoute["overview_polyline"] as! Dictionary<String, Any>
                            
                            let legs = self.selectedRoute["legs"] as! Array<Dictionary<String, Any>>
                            
                            let startLocationDictionary = legs[0]["start_location"] as! Dictionary<String, Any>
                            self.originCoordinate = CLLocationCoordinate2DMake(startLocationDictionary["lat"] as! Double, startLocationDictionary["lng"] as! Double)
                            
                            let endLocationDictionary = legs[legs.count - 1]["end_location"] as! Dictionary<String, Any>
                            self.destinationCoordinate = CLLocationCoordinate2DMake(endLocationDictionary["lat"] as! Double, endLocationDictionary["lng"] as! Double)
                            
                            self.originAddress = legs[0]["start_address"] as! String
                            self.destinationAddress = legs[legs.count - 1]["end_address"] as! String
                            
                            self.calculateTotalDistanceAndDuration()
                            
                            completionHandler(status, true)
                        }
                        else {
                            completionHandler(status, false)
                        }
                    }
                })
            }
            else {
                completionHandler("Destination is nil.", false)
            }
        }
        else {
            completionHandler("Origin is nil", false)
        }
    }
    
    
    func calculateTotalDistanceAndDuration() {
        let legs = self.selectedRoute["legs"] as! Array<Dictionary<String, Any>>
        
        totalDistanceInMeters = 0
        totalDurationInSeconds = 0
        
        for leg in legs {
            totalDistanceInMeters += (leg["distance"] as! Dictionary<String, Any>)["value"] as! UInt
            totalDurationInSeconds += (leg["duration"] as! Dictionary<String, Any>)["value"] as! UInt
        }
        
        
        let distanceInKilometers: Double = Double(totalDistanceInMeters / 1000)
        totalDistance = "Total Distance: \(distanceInKilometers) Km"
        
        
        let mins = totalDurationInSeconds / 60
        let hours = mins / 60
        let days = hours / 24
        let remainingHours = hours % 24
        let remainingMins = mins % 60
        let remainingSecs = totalDurationInSeconds % 60
        
        totalDuration = "Duration: \(days) d, \(remainingHours) h, \(remainingMins) mins, \(remainingSecs) secs"
    }
    
    
}
