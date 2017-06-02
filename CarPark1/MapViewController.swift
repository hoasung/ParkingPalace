//
//  ViewController.swift
//  CarPark1
//
//  Created by thonv on 05/17/17.
//  Copyright © 2017 thonv. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

//import PXGoogleDirections

class MapViewController: UIViewController, CAAnimationDelegate {
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var findPark: UIButton!
    
    @IBOutlet weak var markerInfo: MarkerInfoView!
    
    let api_key = "AIzaSyAMl_O6ExrmOud5p45cY3Uf-RL50Fc0RZU"
    
    var mapTasks = MapTasks()
    
//    var originMarker: GMSMarker!
//    var destinationMarker: GMSMarker!
    var waypointsArray: Array<String> = []
    var routePolyline: GMSPolyline!
    var markersArray: Array<GMSMarker> = []
    
    var travelMode = TravelModes.driving
    var destinationPlace: MarkerPlace? = nil
    var myPlace: MarkerPlace?=nil
    var searchPlaceMarker: MarkerPlace?=nil
    //var placesClient: GMSPlacesClient!
    //var zoomLevel: Float = 15.0
    
//    override func loadView() {
//        // Create a GMSCameraPosition that tells the map to display the
//        // coordinate -33.86,151.20 at zoom level 6.
//        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
//        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
//        view = mapView
//        
//        // Creates a marker in the center of the map.
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
//        marker.title = "Sydney"
//        marker.snippet = "Australia"
//        marker.map = mapView
//    }
//    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        // change to add new location
        let addPlaceController = self.storyboard?.instantiateViewController(withIdentifier: "addParkingPlace") as! AddParkingplaceController
        addPlaceController.lat = coordinate.latitude
        addPlaceController.long1 = coordinate.longitude
        getAddressFromLatLon(pdblLatitude: coordinate.latitude, withLongitude: coordinate.longitude,controllerHander: addPlaceController)
        //addPlaceController.addressValue = getAddressFromLatLon(pdblLatitude: coordinate.latitude, withLongitude: coordinate.longitude)
        //self.present(addPlaceController, animated: true, completion: nil)
        //self.navigationController?.pushViewController(addPlaceController, animated: true)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        markerInfo.isHidden = true
        // Do any additional setup after loading the view, typically from a nib.
        
//        locationManager = CLLocationManager()
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
//        locationManager.distanceFilter = 50
//
        mapView.delegate = self
        mapView.setMinZoom(7, maxZoom: 16)
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        //locationManager.requestAlwaysAuthorization()
        
        findPark.layer.cornerRadius = 25.0
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func searchPlace(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    
    @IBAction func route2Park(_ sender: UIButton) {
        //getRoute(origin: "21.0136222,105.8026002", destination: "21.017707699999999,105.7834431", isDraw: true)
        drawRoute()
    }
    
    func displayMarkerPlace(){
        for place in WSParserMarkerPlace.me.mPlaces{
            place.display(mapView: mapView, isChangeIcon: true)
        }
    }
    
   
    
    func configureMapAndMarkersForRoute() {
        //mapView.camera = GMSCameraPosition.camera(withTarget: mapTasks.originCoordinate, zoom: mapView.camera.zoom)
        
//        originMarker = GMSMarker(position: self.mapTasks.originCoordinate)
//        originMarker.map = self.mapView
//        originMarker.icon = GMSMarker.markerImage(with: UIColor.green)
//        originMarker.title = self.mapTasks.originAddress
//        
//        destinationMarker = GMSMarker(position: self.mapTasks.destinationCoordinate)
//        destinationMarker.map = self.mapView
//        destinationMarker.icon = GMSMarker.markerImage(with: UIColor.red)
//        destinationMarker.title = self.mapTasks.destinationAddress
        
        
        if waypointsArray.count > 0 {
            for waypoint in waypointsArray {
                let lat: Double = (waypoint.components(separatedBy: ",")[0] as NSString).doubleValue
                let lng: Double = (waypoint.components(separatedBy: ",")[1] as NSString).doubleValue
                
                let marker1 = GMSMarker(position: CLLocationCoordinate2DMake(lat, lng))
                //marker.map = self.viewMap
                marker1.map = self.mapView
                marker1.icon = GMSMarker.markerImage(with: UIColor.purple)
                
                markersArray.append(marker1)
            }
        }
    }
    
    
    func drawRoute() {
        
        let route = mapTasks.overviewPolyline["points"] as! String
        
        let path: GMSPath = GMSPath(fromEncodedPath: route)!
        
        routePolyline = GMSPolyline(path: path)
        routePolyline.geodesic = false
        let greenToRed = GMSStrokeStyle.gradient(from: .green, to: .blue) //[GMSStrokeStyle gradientFromColor:[UIColor greenColor] toColor:[UIColor redColor]];
        
        routePolyline.spans = [GMSStyleSpan(style: greenToRed)]
        //routePolyline.spans = [solidBlueSpan]
        //polyline.spans = @[[GMSStyleSpan spanWithStyle:yellowToRed]];
        
        routePolyline.map = mapView
        
        //routePolyline.strokeColor = UIColor.blue
        routePolyline.strokeWidth = 4.0
        var bounds = GMSCoordinateBounds()
        
        for index in 1...path.count() {
            bounds = bounds.includingCoordinate(path.coordinate(at: index))
        }
        
        mapView.animate(with: GMSCameraUpdate.fit(bounds))
    }
    
    
    func displayRouteInfo() {
        
        markerInfo.display(marker: destinationPlace!)
        
    }
    
    
    func clearRoute() {
//        if originMarker != nil{
//            originMarker.map = nil
//        }
//        if destinationMarker != nil{
//            destinationMarker.icon = GMSMarker.markerImage(with: UIColor.blue)
//            destinationMarker.map = nil
//        }
        if routePolyline != nil{
            routePolyline.map = nil
        }
        
//        originMarker = nil
//        destinationMarker = nil
        routePolyline = nil
        
        if  markersArray.count > 0 {
            for marker in markersArray {
                marker.map = nil
            }
            
            markersArray.removeAll(keepingCapacity: false)
        }
    }
    
    
    
    func getRoute(origin: String, destination: String, isDraw: Bool) {
        
        
            self.mapTasks.getDirections(origin, destination: destination, waypoints: nil, travelMode: self.travelMode, completionHandler: { (status, success) -> Void in
                if success {
                    self.configureMapAndMarkersForRoute()
                    if isDraw {
                        self.drawRoute()
                    }
                    self.displayRouteInfo()
                }
                else {
                    print(status)
                }
            })
        
    }
    
    
    func getAddressFromLatLon(pdblLatitude: Double, withLongitude pdblLongitude: Double, controllerHander: AddParkingplaceController) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
       // let lat: Double = Double("\(pdblLatitude)")!
        //21.228124
       // let lon: Double = Double("\(pdblLongitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = pdblLatitude
        center.longitude = pdblLongitude
        var addressString : String = ""
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }
                }
                self.getAddress(addressString: addressString, showController: controllerHander)
        })
        print(addressString);
//        return addressString
    }
    
    func getAddress(addressString: String,showController: AddParkingplaceController) {
        showController.addressValue = addressString
        self.navigationController?.pushViewController(showController, animated: true)
        
    }
    
    
}


