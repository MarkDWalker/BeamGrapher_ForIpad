//
//  iosNumUtil.swift
//  BeamGrapherForIpadV_0.0.3
//
//  Created by Mark Walker on 6/9/15.
//  Copyright (c) 2015 Mark Walker. All rights reserved.
//

import UIKit

class iosNumUtil: NSObject {
    
   override init(){
        super.init()
    }

    
    func txtToD(_ theString:String)->Double{
        let theNumber = NumberFormatter().number(from: theString)
        let returnVal = theNumber?.doubleValue
        return returnVal!
    }
    
    func txtToI(_ theString:String)->Int{
        let theNumber = NumberFormatter().number(from: theString)
        let returnVal = theNumber?.intValue
        return returnVal!
    }
    
   
}
