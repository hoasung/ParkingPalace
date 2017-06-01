import GoogleMaps
import GooglePlaces
//
//  GooglePlaceExtension.swift
//  CarPark1
//
//  Created by thonv on 05/22/17.
//  Copyright © 2017 thonv. All rights reserved.
//

// MARK: - GMSMapViewDelegate
extension MapViewController: GMSMapViewDelegate {
    
    //    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
    //        let marker = MarkerPlace()
    //        marker.position = coordinate
    //        marker.title = ""
    //        marker.snippet = ""
    //        marker.map = mapView
    //        marker.makeIcon()
    //        //marker.icon = GMSMarker.markerImage(with: UIColor.green)
    //    }
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        if let myLocation = mapView.myLocation {
            clearRoute()
            //            marker.icon = GMSMarker.markerImage(with: UIColor.orange)
            if marker is MarkerPlace{
                destinationPlace = marker as? MarkerPlace
                //destinationPlace?.blink(delegate: self)
                //self.blink(marker: destinationPlace!)
            }
            else {
                destinationPlace = MarkerPlace(marker: marker)
                //destinationPlace?.blink(delegate: self)
                //self.blink(marker: destinationPlace!)
            }
            let origin = String(myLocation.coordinate.latitude) + "," + String(myLocation.coordinate.longitude)
            let destination = "\(marker.position.latitude),\(marker.position.longitude)"
            getRoute(origin: origin , destination: destination, isDraw: false)
        }
        return true
    }
    
}
extension MapViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        if self.searchPlaceMarker != nil{
            self.searchPlaceMarker?.map = nil
        }
        self.searchPlaceMarker = MarkerPlace(name: place.name, addr: place.formattedAddress!,  pos: CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude))
        self.searchPlaceMarker?.icon = GMSMarker.markerImage(with: UIColor.green)
        //self.searchPlaceMarker?.map = self.mapView
        self.searchPlaceMarker?.display(mapView: self.mapView, isChangeIcon: false)
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}


// MARK: - CLLocationManagerDelegate
//1
extension MapViewController: CLLocationManagerDelegate {
    // 2
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // 3
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            
            // 4
            locationManager.startUpdatingLocation()
            
            //5
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = false
            
        }
        
    }
    
    
    // 6
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            
            // 7
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 12, bearing: 0, viewingAngle: 0)
            
            // 8
            locationManager.stopUpdatingLocation()
            
            
            
            myPlace = MarkerPlace(name: "My Location", addr: "", pos: location)
            WSParserMarkerPlace.me.doSearch(myLocation: location.coordinate)
            
            print("count: \(WSParserMarkerPlace.me.mPlaces.count)")
            displayMarkerPlace()
            
            clearRoute()
            //marker.icon = GMSMarker.markerImage(with: UIColor.orange)
            
            if let destPlace = WSParserMarkerPlace.me.nearestPlace {
                destinationPlace = destPlace
                //destinationPlace?.blink(delegate: self)
                //self.blink(marker: destinationPlace!)
                let origin = String(location.coordinate.latitude) + "," + String(location.coordinate.longitude)
                let destination = "\(destPlace.position.latitude),\(destPlace.position.longitude)"
                getRoute(origin: origin , destination: destination, isDraw: false)
                
                
            }
            
            
            
        }
        
    }
    
}
