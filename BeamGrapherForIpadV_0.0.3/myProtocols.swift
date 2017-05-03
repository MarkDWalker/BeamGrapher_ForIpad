//
//  myProtocols.swift
//  BeamGrapherForIpadV_0.0.3
//
//  Created by Mark Walker on 6/7/15.
//  Copyright (c) 2015 Mark Walker. All rights reserved.
//

import UIKit

protocol MyCellDelegator {
    func callSegueFromCell(_ theSender: AnyObject, theSegueIdentifier:String)
}

protocol MyEditBeamGeoDelegator{
    func updateBeamGeo(_ beam:MWBeamGeometry)
}

protocol MyEditLoadDelegator{
    func updateLoad(_ load:MWLoadData, indexOfLoad:Int)
}
