//
//  CustomCell_LoadData.swift
//  BeamGrapherForIpadV_0.0.3
//
//  Created by Mark Walker on 6/9/15.
//  Copyright (c) 2015 Mark Walker. All rights reserved.
//

import UIKit

class CustomCell_LoadData: UITableViewCell {

    var delegate:MyCellDelegator?
    
    
    
    @IBOutlet weak var loadDescription: UILabel!
    @IBOutlet weak var loadType: UILabel!
    @IBOutlet weak var loadValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btn_Pressed(_ sender: AnyObject) {
        if(self.delegate != nil){ //Just to be safe.
            self.delegate!.callSegueFromCell(sender,theSegueIdentifier:"EditLoad")
        }
    }

}
