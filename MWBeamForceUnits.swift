//
//  MWBeamForceUnits.swift
//  BeamGrapherForIpadV_0.0.3
//
//  Created by Mark Walker on 6/15/15.
//  Copyright (c) 2015 Mark Walker. All rights reserved.
//

import UIKit

enum lengthUnitsEnum:String{
    case inches = "inches"
    case feet = "feet"
    case meter = "meters"
    case centimeter = "centimeters"
    
}

enum forceUnitsEnum:String{
    case pounds = "lbs"
    case kips = "kips"
    case newton = "newtons"
    case kilonewton = "kilonewtons"
    
}

//enum momentUnitsEnum:String{
//    case footkips = "foot-kips"
//    case inchkips = "inch-kips"
//    case footPounds = "foot-lbs"
//    case inchPounds = "inch-lbs"
//    case newtonMeter = "newton--meter"
//    case
//}

enum deflectionUnitsEnum:String{
    case inches = "inches"
    case feet = "feet"
    case meter = "meters"
    case centimeter = "centimeters"
}



class MWBeamForceUnits: NSObject {
    
    var lengthUnits:lengthUnitsEnum = .feet
    var forceUnits:forceUnitsEnum = .kips
    var deflectionUnits:deflectionUnitsEnum = .inches
    
   
}
