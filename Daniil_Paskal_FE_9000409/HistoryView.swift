//
//  HistoryView.swift
//  Daniil_Paskal_FE_9000409
//
//  Created by user237236 on 4/12/24.
//

import UIKit

class HistoryView: UITableViewController {
    // Reference object to manage content
    let content = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // Array of history items
    var history: [HistoryItem]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set screen as tableview data source and delegate
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        // Set row height
        self.tableView.rowHeight = 150
        
        // Load search history
        fetchHistory()
    }
    
    // Get history items from memory
    func fetchHistory() {
        do {
            self.history = try content.fetch(HistoryItem.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("No history found")
        }
    }
    
    // Set number of sections to 1
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // Set number of rows equal to number of articles
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.history?.count ?? 0
    }
    
    // Generate and reuse cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIdentifier = "history\(self.history?[indexPath.row].type ?? "")Cell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! HistoryTableViewCell
        
        cell.labelType.text = self.history?[indexPath.row].type
        cell.labelCity.text = self.history?[indexPath.row].city
        
        // Fill cell labels based on cell identifier
        switch (cellIdentifier) {
        case "historyNewsCell":
            // Fill news cell with article data
            cell.labelTitle.text = self.history?[indexPath.row].data[0]
            cell.labelDescription.text = self.history?[indexPath.row].data[1]
            cell.labelSource.text = self.history?[indexPath.row].data[2]
            cell.labelAuthor.text = self.history?[indexPath.row].data[3]
            
            break;
        case "historyMapCell":
            // Fill map cell with route data
            cell.labelSide1.text = self.history?[indexPath.row].data[0]
            cell.labelSide2.text = self.history?[indexPath.row].data[1]
            cell.labelTravel.text = self.history?[indexPath.row].data[2]
            cell.labelDistance.text = self.history?[indexPath.row].data[3]
            
            break;
        case "historyWeatherCell":
            // Fill weather cell with date and weather data
            cell.labelSide1.text = self.history?[indexPath.row].data[0]
            cell.labelSide2.text = self.history?[indexPath.row].data[1]
            cell.labelTemp.text = self.history?[indexPath.row].data[2]
            cell.labelHumidity.text = self.history?[indexPath.row].data[3]
            cell.labelWind.text = self.history?[indexPath.row].data[4]
            
            break;
        default:
            break;
        }

        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let todoToRemove = self.history![indexPath.row]
            self.content.delete(todoToRemove)
            
            do {
                try self.content.save()
            } catch {
                print("Error saving data")
            }
            
            self.history?.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

