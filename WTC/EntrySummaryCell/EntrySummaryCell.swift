//
//  EntrySummaryCell.swift
//  WTC
//
//  Created by Lorenzo Ferrante on 3/2/20.
//  Copyright © 2020 Lorenzo Ferrante. All rights reserved.
//

import UIKit

class EntrySummaryCell: UITableViewCell {
    
    @IBOutlet var name: UILabel!
    @IBOutlet var desc: UILabel!
    @IBOutlet var quantity: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
