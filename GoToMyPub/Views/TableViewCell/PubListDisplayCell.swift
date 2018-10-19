//
//  PubListDisplayCell.swift
//  GotoMyPub
//
//  Created by Swapnil Katkar on 11/05/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class PubListDisplayCell: UITableViewCell {

    @IBOutlet weak var listHolderView: UIView!
    
    @IBOutlet weak var pubName: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!

    @IBOutlet weak var infoHolderView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

