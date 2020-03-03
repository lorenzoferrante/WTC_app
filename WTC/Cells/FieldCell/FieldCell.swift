//
//  FieldCell.swift
//  WTC
//
//  Created by Lorenzo Ferrante on 3/3/20.
//  Copyright © 2020 Lorenzo Ferrante. All rights reserved.
//

import UIKit

class FieldCell: UITableViewCell {
    
    @IBOutlet weak var textField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
