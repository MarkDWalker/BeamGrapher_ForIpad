//
//  CustomCell_GridData.swift
//  BeamGrapherForIpadV_0.0.3
//
//  Created by Mark Walker on 6/18/15.
//  Copyright (c) 2015 Mark Walker. All rights reserved.
//

import UIKit

class CustomCell_GridData: UITableViewCell {

    @IBOutlet weak var Label1: UILabel!
    @IBOutlet weak var Label2: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        var customFrame:CGRect = self.frame
//        customFrame.size.height = 30
//        
//        self.frame.size.height = 30
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
