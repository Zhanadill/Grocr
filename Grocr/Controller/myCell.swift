//
//  myCell.swift
//  Grocr
//
//  Created by Жанадил on 2/28/21.
//  Copyright © 2021 Жанадил. All rights reserved.
//

import UIKit

class myCell: UITableViewCell {
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
