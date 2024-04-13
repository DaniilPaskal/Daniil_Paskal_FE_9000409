//
//  DirectionsView.swift
//  Daniil_Paskal_FE_9000409
//
//  Created by user237236 on 4/10/24.
//

import UIKit
import CoreLocation
import MapKit

class DirectionsView: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    // Location manager
    let manager = Location.manager
    // Transport method
    var transport: MKDirectionsTransportType = .any
    
    // Slider for setting zoom level
    @IBOutlet weak var sliderZoom: UISlider!
    
    // Change zoom level on slider change
    @IBAction func setZoom(_ sender: Any) {
        // Get delta by multiplying slider value
        let sliderValue = Double(self.sliderZoom.value)
        let delta = sliderValue * 20
        
        // Set region span to delta
        var region = self.map.region
        region.span = MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
        self.map.region = region
    }
    
    // Button to set mode of travel as car
    @IBAction func buttonCar(_ sender: Any) {
        transport = .automobile
        // Redraw route
        mapThis()
    }
    
    // Button to set mode of travel as bike (equivalent to walking)
    @IBAction func buttonBike(_ sender: Any) {
        transport = .walking
        // Redraw route
        mapThis()
    }
    
    // Button to set mode of travel as walking
    @IBAction func buttonWalk(_ sender: Any) {
        transport = .walking
        // Redraw route
        mapThis()
    }
    
    // Button to set mode of travel as transit
    @IBAction func buttonTransit(_ sender: Any) {
        transport = .transit
        // Redraw route
        mapThis()
    }
    
    // Map view
    @IBOutlet weak var map: MKMapView!
    
    // Button to change city
    @IBAction func buttonCity(_ sender: Any) {
        // Present city change alert
        self.present(changeLocation() { self.mapThis() }, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set location manager settings and start updating location
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        map.delegate = self
        
        // Set initiaal location
        render()
        
        // Set zoom level to slider middle
        setZoom(self)
    }
    
    // Set region and pin for original location on map
    func render () {
        // Get global location
        let location = Location.startLocation
        // Get coordinates
        let coordinate = CLLocationCoordinate2D (latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude )

        // Initialize span, region, pin
        let span = MKCoordinateSpan(latitudeDelta: 4.9, longitudeDelta: 4.9)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        let pin = MKPointAnnotation ()

        // Set pin and region
        pin.coordinate = coordinate
        map.addAnnotation(pin)
        map.setRegion(region, animated: true)
    }
    
    // Create polyline overlay
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let routeline = MKPolylineRenderer(overlay: overlay )
        routeline.strokeColor = .blue
        return routeline
    }
    
    // Add pin and route for desired destination
    func mapThis() {
        // Get coordinates from global location
        let desiredLocation = Location.location?.coordinate
        // Get source coordinates
        let sourceCoordinate = (manager.location?.coordinate)!
        // Placemarks for source and destination
        let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinate)
        let destinationPlacemark = MKPlacemark(coordinate: desiredLocation!)
        
        let sourceItem = MKMapItem(placemark: sourcePlacemark)
        let destinationItem = MKMapItem(placemark: destinationPlacemark)
        
        // Request directions
        let destinationRequest = MKDirections.Request()
        destinationRequest.source = sourceItem
        destinationRequest.destination = destinationItem
        
        // Set transport type
        destinationRequest.transportType = transport
        destinationRequest.requestsAlternateRoutes = true
        
        // Get directions
        let directions = MKDirections(request: destinationRequest)
        directions.calculate { response,error in
            guard let response = response else {
                if error != nil {
                    print("Error planning route")
                }
                return
            }
            
            // Add route to map
            let route = response.routes[0]
            self.map.addOverlay(route.polyline)
            self.map.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            
            // Add end point pin
            let pin = MKPointAnnotation()
            let coordinate = CLLocationCoordinate2D(latitude: desiredLocation!.latitude, longitude: desiredLocation!.longitude)
            pin.coordinate = coordinate
            pin.title = Location.locationName
            self.map.addAnnotation(pin)
            
            // If not at starting location, save search, passing route data
            if (Location.location != Location.startLocation) {
                saveMap(startPoint: sourceCoordinate, endPoint: desiredLocation!, travel: self.transport, distance: route.distance)
                
                // Reset location
                Location.location = Location.startLocation
            }
        }
        
    }
}
