//
//  NewsView.swift
//  Daniil_Paskal_FE_9000409
//
//  Created by user237236 on 4/10/24.
//

import UIKit
import CoreLocation

class NewsView: UITableViewController, CLLocationManagerDelegate {
    //Location manager
    let manager = Location.manager
    // Array of articles
    var articles: [Article]?
    
    // Button to launch alert to change city
    @IBAction func buttonCity(_ sender: Any) {
        // Present city change alert, pass news API call (pass new location)
        self.present(changeLocation() { self.makeNewsAPICall(location: Location.location!) }, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set location manager settings and start updating location
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        
        // Set screen as tableview data source and delegate
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        // Set row height
        self.tableView.rowHeight = 128
        
        // Make initial API call (pass start location)
        makeNewsAPICall(location: Location.startLocation!)
    }
    
    // Get news JSON data
    func makeNewsAPICall(location: CLLocation) {
        // Location name
        let locationName = Location.locationName
        print(locationName)

        // Create URL using location name
        guard let url = URL(string: "https://newsapi.org/v2/everything?q=\(locationName)&apiKey=905732841e504ee3a845577573ae035a") else { return }
        
        print("https://newsapi.org/v2/everything?q=\(locationName)&apiKey=905732841e504ee3a845577573ae035a")
            
        // Fetch JSON data from server using URL
        let task = URLSession.shared.dataTask(with: url) {
            data, response, error in
                
            // If data received from server, proceed
            if let data = data {
        
            do {
                // Decode data using News struct
                let jsonData = try JSONDecoder().decode(News.self, from: data)
                    
                // Pass news data to update article array on view thread and reload table data
                DispatchQueue.main.async {
                    self.articles = jsonData.articles
                    self.tableView.reloadData()
                    
                    // If not at starting location, save search, passing first article
                    if (Location.location != Location.startLocation) {
                        saveNews(article: jsonData.articles[0])
                        
                        // Reset location
                        Location.location = Location.startLocation
                    }
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
    
    // Set number of sections to 1
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // Set number of rows equal to number of articles
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles?.count ?? 0
    }
    
    // Generate and reuse cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsTableViewCell
        
        // Set cell labels with article data
        cell.labelTitle.text = self.articles?[indexPath.row].title
        cell.labelDescription.text = self.articles?[indexPath.row].description
        cell.labelSource.text = self.articles?[indexPath.row].source.name
        cell.labelAuthor.text = self.articles?[indexPath.row].author

        return cell
    }
}
