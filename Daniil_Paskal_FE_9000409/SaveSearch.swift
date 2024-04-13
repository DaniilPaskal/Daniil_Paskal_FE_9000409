//
//  SaveSearch.swift
//  Daniil_Paskal_FE_9000409
//
//  Created by user237236 on 4/13/24.
//

import Foundation
import UIKit
import MapKit

// Functions for saving searches from different screens

// Reference object to manage content
let content = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Save news search
func saveNews(article: Article) {
    // Create new history item
    let newSearch = HistoryItem(context: content)
        
    // Set history item attributes
    newSearch.type = "News"
    newSearch.source = "News"
    newSearch.city = Location.locationName
    // Put article data in array (less elegant and maintainable than a struct or class but much simpler)
    newSearch.data = [article.title, article.description ?? "", article.source.name, article.author ?? ""]
        
    // Save new history item to database
    do {
        try content.save()
    } catch {
        print("Error saving data")
    }
}
    
// Save map search
func saveMap(startPoint: CLLocationCoordinate2D, endPoint: CLLocationCoordinate2D, travel: MKDirectionsTransportType, distance: CLLocationDistance) {
    // Create new history item
    let newSearch = HistoryItem(context: content)
    
    // Convert transport type to readable format
    var travelString = "Any"
    switch (travel) {
    case .automobile:
        travelString = "Automobile"
        break;
    case .walking:
        travelString = "Walking"
        break;
    case .transit:
        travelString = "Transit"
        break;
    default:
        break;
    }
    
    // Set history item attributes
    newSearch.type = "Map"
    newSearch.source = "Map"
    newSearch.city = Location.locationName
    // Put map data in array
    newSearch.data = [String(format: "%.2f, %.2f", startPoint.latitude, startPoint.longitude), String(format: "%.2f, %.2f", endPoint.latitude, endPoint.longitude), "Method: \(travelString)", String(format: "Distance: %.2f km", distance / 1000)]
    
    // Save new history item to database
    do {
        try content.save()
    } catch {
        print("Error saving data")
    }
}
    
// Save weather search
func saveWeather(weather: Weather) {
    // Create new history item
    let newSearch = HistoryItem(context: content)
        
    // Get and format date of search
    let date = Date()
    let dateFormatter = DateFormatter()
    let timeFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    timeFormatter.dateFormat = "HH:mm:ss"
        
    // Set history item attributes
    newSearch.type = "Weather"
    newSearch.source = "Weather"
    newSearch.city = Location.locationName
    // Put weather data and date/time in array
    newSearch.data = [dateFormatter.string(from: date), timeFormatter.string(from:date), "\(Int(weather.main.temp - 273.15))°", "Humidity: \(weather.main.humidity)%", "Wind: \(weather.wind.speed) km/h"]
    
    // Save new history item to database
    do {
        try content.save()
    } catch {
        print("Error saving data")
    }
}
