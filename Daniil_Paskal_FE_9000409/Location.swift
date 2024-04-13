//
//  Location.swift
//  Daniil_Paskal_FE_9000409
//
//  Created by user237236 on 4/12/24.
//

import Foundation
import CoreLocation
import UIKit

// File for global location variables and functions pertaining to location

/*
 In retrospect, these global variables are probably unnecessary.
 I started working on this section without fully grasping the
 role of locations in the app, thinking there would be more need
 for set locations to be shared between screens, leading to this
 somewhat awkward structure. However, putting the location here
 remains useful for keeping the change location alert as a function
 that can be called by different screens and used to call perform
 different tasks with the location.
*/

// Struct for location variables
struct Location {
    // Global location manager
    static var manager = CLLocationManager()
    // Global location
    static var location = manager.location
    // Global location name
    static var locationName = ""
    
    // Starting location (doesn't change)
    static let startLocation = location
}

// Get name of location from coordinates
func setLocationName(location: CLLocation) {
    // Use geocoder to convert coordinates to place name
    let geocoder = CLGeocoder()
    geocoder.reverseGeocodeLocation(location) { placemarks, error in
        guard let placemark = placemarks?.first
        else {
            return
        }
        
        // Set global variable with location name
        Location.locationName = placemark.locality!
    }
}

// Return alert to change city; call appropriate function that uses location
func changeLocation(callClosure: @escaping () -> Void) -> UIAlertController {
    // Create alert
    let alert = UIAlertController(title: "Where would you like to go?", message: nil, preferredStyle: .alert)
    
    // Add field for city name
    alert.addTextField{ (cityField) in
        cityField.placeholder = "Enter your new destination here:"
    }
    
    // Add cancel button
    alert.addAction(UIAlertAction(title: "Cancel", style: .default) { (alertAction) in
    })
    
    // Add ok button
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [unowned alert] (action) -> Void in
        let cityField = alert.textFields![0] as UITextField
        
        // Use geocoder to convert address to coordinates
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(cityField.text!) {
            (placemarks, error) in
            guard let placemarks = placemarks,
                  let location = placemarks.first?.location
            else {
                print("Error with location")
                return
            }
        
            // Set global variables with location coordinates and name
            Location.location = location
            Location.locationName = cityField.text!
            
            // Call given function
            callClosure()
        }
    }))
    
    return alert
}
