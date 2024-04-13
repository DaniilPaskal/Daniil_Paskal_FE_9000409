//
//  ViewController.swift
//  Daniil_Paskal_FE_9000409
//
//  Created by user237236 on 4/6/24.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    // Location manager
    let manager = Location.manager
    
    // Map view
    @IBOutlet weak var map: MKMapView!
    
    // Temperature label
    @IBOutlet weak var labelTemp: UILabel!
    
    // Humidity label
    @IBOutlet weak var labelHumidity: UILabel!
    
    // Wind speed label
    @IBOutlet weak var labelWind: UILabel!
    
    // Weather type icon
    @IBOutlet weak var imageIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set location manager settings and start updating location
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
    }
    
    // et initial location, make initial weather API call
    func locationManager(_ manager: CLLocationManager, didUpdateLocations location: [CLLocation]) {
        render()
        makeWeatherAPICall()
        
        // Set global location name variable to be used by later screens
        setLocationName(location: Location.startLocation!)
        
        // Stop updating location to allow later screens to restart
        manager.stopUpdatingLocation()
    }
    
    // Set region and pin for original location on map
    func render () {
        // Get start location
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
    
    // Get weather JSON data
        func makeWeatherAPICall() {
            // Get start location
            let location = Location.startLocation!
            // Location coordinates
            let coordinate = location.coordinate

            // Create URL using location latitude and longitude
            guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(String(describing: coordinate.latitude))&lon=\(String(describing: coordinate.longitude))&appid=d3f0956caa7ad29a06e029f9a9cb7c0e") else { return }
            
            // Fetch JSON data from server using URL
            let task = URLSession.shared.dataTask(with: url) {
                data, response, error in
                
                // If data received from server, proceed
                if let data = data {
        
                do {
                    // Decode data using Weather struct
                    let jsonData = try JSONDecoder().decode(Weather.self, from: data)
                    
                    // Pass weather data to update labels on view thread
                    DispatchQueue.main.async {
                        self.updateLabels(weather: jsonData)
                    }
                } catch {
                    print("Error decoding data.")
                }
            } else {
                print("Error getting data from server.")
            }
        }
        task.resume()
    }

    // Get weather icon image
    func getWeatherIcon(icon: String) {
        // Create URL using icon string
        guard let url = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")
        else {
            return
        }
        
        // Fetch image from server using URL
        let task = URLSession.shared.dataTask(with: url) {
            data, response, error in
        
            // If image received from server, proceed
            if let data = data {
                // Set image to received icon on main thread
                DispatchQueue.main.async {
                    self.imageIcon.image = UIImage(data: data)
                }
            } else {
                print("Error getting icon from server.")
            }
        }
        task.resume()
    }
    
    // Update view with weather data
    func updateLabels(weather: Weather) {
        // Get needed variables from decoded data
        let icon = weather.weather[0].icon
        let temp = Int(weather.main.temp - 273.15)
        let humidity = weather.main.humidity
        let wind = weather.wind.speed
        
        // Set labels to corresponding variables
        labelTemp.text = "\(temp)°"
        labelHumidity.text = "Humidity: \(humidity)%"
        labelWind.text = "Wind: \(wind) km/h"
        
        // Get icon image
        getWeatherIcon(icon: icon)
    }
}

