//
//  CustomCell_EditBeam.swift
//  BeamGrapherForIpadV_0.0.3
//
//  Created by Mark Walker on 6/6/15.
//  Copyright (c) 2015 Mark Walker. All rights reserved.
//

import UIKit

class CustomCell_EditBeam: UITableViewCell {

    var delegate:MyCellDelegator?
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

//    @IBAction func button_Pressed(theSender: AnyObject) {
//        //var mydata = "Anydata you want to send to the next controller"
//        if(self.delegate != nil){ //Just to be safe.
//            self.delegate!.callSegueFromCell(theSender)
//        }
//    }
    
    @IBAction func btn_Pressed(_ sender: AnyObject) {
        if(self.delegate != nil){ //Just to be safe.
            self.delegate!.callSegueFromCell(sender, theSegueIdentifier: "EditBeam" )
        }
    }
    
}
