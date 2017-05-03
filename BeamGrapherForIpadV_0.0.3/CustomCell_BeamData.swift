//
//  CustomCell_BeamData.swift
//  BeamGrapherForIpadV_0.0.3
//
//  Created by Mark Walker on 6/7/15.
//  Copyright (c) 2015 Mark Walker. All rights reserved.
//

import UIKit

class CustomCell_BeamData: UITableViewCell {

    @IBOutlet weak var label_Description: UILabel!
    
    @IBOutlet weak var label_Value: UILabel!
    @IBOutlet weak var label_Units: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
