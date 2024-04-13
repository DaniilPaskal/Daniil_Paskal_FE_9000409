//
//  NewsTableViewCell.swift
//  Daniil_Paskal_FE_9000409
//
//  Created by user237236 on 4/10/24.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    // Label for article title
    @IBOutlet weak var labelTitle: UILabel!
    
    // Label for article description
    @IBOutlet weak var labelDescription: UILabel!
    
    // Label for article source
    @IBOutlet weak var labelSource: UILabel!
    
    // Label for article author
    @IBOutlet weak var labelAuthor: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
