//
//  HistoryTableViewCell.swift
//  Daniil_Paskal_FE_9000409
//
//  Created by user237236 on 4/13/24.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    // Label for type of search
    @IBOutlet weak var labelType: UILabel!
    
    // Label for searched location
    @IBOutlet weak var labelCity: UILabel!
    
    // Label for start point in map cell, date in weather cell
    @IBOutlet weak var labelSide1: UILabel!
    
    // Label for end point in map cell, time in weather cell
    @IBOutlet weak var labelSide2: UILabel!
    
    // Label for article title
    @IBOutlet weak var labelTitle: UILabel!
    
    // Label for article description
    @IBOutlet weak var labelDescription: UILabel!
    
    // Label for article source
    @IBOutlet weak var labelSource: UILabel!
    
    // Label for article author
    @IBOutlet weak var labelAuthor: UILabel!
    
    // Label for travel method
    @IBOutlet weak var labelTravel: UILabel!
    
    // Label for distance travelled
    @IBOutlet weak var labelDistance: UILabel!
    
    // Label for temperature
    @IBOutlet weak var labelTemp: UILabel!
    
    // Label for humidity
    @IBOutlet weak var labelHumidity: UILabel!
    
    // Label for wind speed
    @IBOutlet weak var labelWind: UILabel!
    
    
    @IBAction func buttonNews(_ sender: Any) {
        
    }
    
    @IBAction func buttonMap(_ sender: Any) {
    }
    
    @IBAction func buttonWeather(_ sender: Any) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
