//
//  CoinTableViewCell.swift
//  watch_custom
//
//  Created by Aaron Rotem on 12/21/17.
//  Copyright © 2017 Aaron Rotem. All rights reserved.
//

import UIKit

class CoinTableViewCell: UITableViewCell {
    //MARK: properties
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var changelLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
