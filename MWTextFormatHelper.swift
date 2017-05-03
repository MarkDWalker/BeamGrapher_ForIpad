//
//  MWTextFormatHelper.swift
//  BeamDesigner
//
//  Created by Mark Walker on 4/12/15.
//  Copyright (c) 2015 Mark Walker. All rights reserved.
//

import UIKit

class MWTextFormatHelper: NSObject {

    var verdanaNormal:NSDictionary = NSDictionary()
    var verdanaTitle:NSDictionary = NSDictionary()
    var verdanaNormalRedHL:NSDictionary = NSDictionary()
    var verdanaNormalGreenHL:NSDictionary = NSDictionary()
    var verdanaBold:NSDictionary = NSDictionary()
    var verdanaSuper:NSDictionary = NSDictionary()
    var verdanaSub:NSDictionary = NSDictionary()
    
    var normalFontSize:Int = 13 //pt
    var superSciptSize:Int = 8
    var superScriptOffset:CGFloat = 5
    
    
    override init(){
        super.init()
        superSciptSize = Int(Double(normalFontSize)/1.2)
        superScriptOffset = CGFloat(normalFontSize)/3
        
        verdanaTitle = self.setAttributesVerdanaBold(normalFontSize)
        verdanaNormal = self.setAttributesVerdana(normalFontSize)
        verdanaNormalRedHL = self.setAttributesVerdana(normalFontSize, highlightColor: UIColor.red)
        verdanaNormalGreenHL = self.setAttributesVerdana(normalFontSize, highlightColor: UIColor.green)
        verdanaBold = self.setAttributesVerdanaBold((normalFontSize-1))
        verdanaSuper = self.setAttributesVerdanaBold(superSciptSize, script: superScriptOffset)
        verdanaSub = self.setAttributesVerdanaBold(superSciptSize, script: -superScriptOffset)
    }
    
    func setAttributesTimes(_ fontSize:Int?=12, highlightColor:UIColor?=UIColor.white, textColor:UIColor?=UIColor.black, script:CGFloat? = 0)->NSMutableDictionary{
        
        //script is either -, + or 0 for subscript, superscript, or normal script
        
        let returnDict:NSMutableDictionary = NSMutableDictionary()
        
       let myFont:UIFont = UIFont(name: "Times New Roman", size: CGFloat(fontSize!))!
        
        returnDict.setObject(myFont, forKey: NSFontAttributeName as NSCopying)
        returnDict.setObject(highlightColor!, forKey: NSBackgroundColorAttributeName as NSCopying)
        returnDict.setObject(textColor!, forKey: NSForegroundColorAttributeName as NSCopying)
        returnDict.setObject(script!, forKey: NSBaselineOffsetAttributeName as NSCopying)
        
        return returnDict
    }
    
    func setAttributesVerdana(_ fontSize:Int?=12, highlightColor:UIColor?=UIColor.white, textColor:UIColor?=UIColor.black, script:CGFloat? = 0)->NSMutableDictionary{
        
        //script is either -, + or 0 for subscript, superscript, or normal script
        
        let returnDict:NSMutableDictionary = NSMutableDictionary()
        
        let myFont:UIFont = UIFont(name: "Verdana", size: CGFloat(fontSize!))!
        
        returnDict.setObject(myFont, forKey: NSFontAttributeName as NSCopying)
        returnDict.setObject(highlightColor!, forKey: NSBackgroundColorAttributeName as NSCopying)
        returnDict.setObject(textColor!, forKey: NSForegroundColorAttributeName as NSCopying)
        returnDict.setObject(script!, forKey: NSBaselineOffsetAttributeName as NSCopying)
        
        return returnDict
    }
    
    func setAttributesVerdanaBold(_ fontSize:Int?=12, highlightColor:UIColor?=UIColor.white, textColor:UIColor?=UIColor.black, script:CGFloat? = 0)->NSMutableDictionary{
        
        //script is either -, + or 0 for subscript, superscript, or normal script
        
        let returnDict:NSMutableDictionary = NSMutableDictionary()
        
        let myFont:UIFont = UIFont(name: "Verdana-Bold", size: CGFloat(fontSize!))!
        
        returnDict.setObject(myFont, forKey: NSFontAttributeName as NSCopying)
        returnDict.setObject(highlightColor!, forKey: NSBackgroundColorAttributeName as NSCopying)
        returnDict.setObject(textColor!, forKey: NSForegroundColorAttributeName as NSCopying)
        returnDict.setObject(script!, forKey: NSBaselineOffsetAttributeName as NSCopying)
        
        return returnDict
    }
    
     func nAttString(_ theString:String)->NSMutableAttributedString{
        let mAString:NSMutableAttributedString = NSMutableAttributedString(string:theString, attributes: verdanaNormal as? [String : AnyObject])
        return mAString
    }
    
    func nAttStringRedHL(_ theString:String)->NSMutableAttributedString{
        let mAString:NSMutableAttributedString = NSMutableAttributedString(string:theString, attributes: verdanaNormalRedHL as? [String : AnyObject])
        return mAString
    }
    
    func nAttStringGreenHL(_ theString:String)->NSMutableAttributedString{
        let mAString:NSMutableAttributedString = NSMutableAttributedString(string:theString, attributes: verdanaNormalGreenHL as? [String : AnyObject])
        return mAString
    }
    
    
    func nBAttString(_ theString:String)->NSMutableAttributedString{
        let mAString:NSMutableAttributedString = NSMutableAttributedString(string:theString, attributes: verdanaBold as? [String : AnyObject])
        return mAString
    }
    
    func subAttString(_ theString:String)->NSMutableAttributedString{
        let mAString:NSMutableAttributedString = NSMutableAttributedString(string:theString, attributes: verdanaSub as? [String : AnyObject])
        return mAString
    }
    
    func superAttString(_ theString:String)->NSMutableAttributedString{
        let mAString:NSMutableAttributedString = NSMutableAttributedString(string:theString, attributes: verdanaSuper as? [String : AnyObject])
        return mAString
    }
}
