//
//  ViewController_EditLoad.swift
//  BeamGrapherForIpadV_0.0.3
//
//  Created by Mark Walker on 6/8/15.
//  Copyright (c) 2015 Mark Walker. All rights reserved.
//

import UIKit

class ViewController_EditLoad: UIViewController {
    var delegate:MyEditLoadDelegator?
    
    var myNums:iosNumUtil = iosNumUtil() //my number conversion utility
    
    var theBeam:MWBeamGeometry = MWBeamGeometry()
    var theLoad:MWLoadData = MWLoadData()
    var theLoadIndex:Int = 0
    
    @IBOutlet weak var tv_Description: UITextField!
    @IBOutlet weak var tv_LoadValue: UITextField!
    @IBOutlet weak var switch_Concentrated: UISwitch!
    @IBOutlet weak var switch_Uniform: UISwitch!
    @IBOutlet weak var switch_LinearUp: UISwitch!
    @IBOutlet weak var switch_LinearDown: UISwitch!
    @IBOutlet weak var tv_SartLocation: UITextField!
    @IBOutlet weak var tv_EndLocation: UITextField!
    
    
    
    func setLoadTypeSwitch(){
        if theLoad.loadType == loadTypeEnum.concentrated{
            switch_Concentrated.setOn(true, animated:true)
            switch_Uniform.setOn(false, animated: true)
            switch_LinearUp.setOn(false, animated: true)
            switch_LinearDown.setOn(false, animated: true)
        }else if theLoad.loadType == loadTypeEnum.uniform{
            switch_Concentrated.setOn(false, animated:true)
            switch_Uniform.setOn(true, animated: true)
            switch_LinearUp.setOn(false, animated: true)
            switch_LinearDown.setOn(false, animated: true)
        }else if theLoad.loadType == loadTypeEnum.linearUp{
            switch_Concentrated.setOn(false, animated:true)
            switch_Uniform.setOn(false, animated: true)
            switch_LinearUp.setOn(true, animated: true)
            switch_LinearDown.setOn(false, animated: true)
        }else if theLoad.loadType == loadTypeEnum.linearDown{
            switch_Concentrated.setOn(false, animated:true)
            switch_Uniform.setOn(false, animated: true)
            switch_LinearUp.setOn(false, animated: true)
            switch_LinearDown.setOn(true, animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
        tv_Description.text = theLoad.loadDescription
        
        if theLoad.loadType == loadTypeEnum.linearUp{
            tv_LoadValue.text = "\(theLoad.loadValue2)"
        }else{
            tv_LoadValue.text = "\(theLoad.loadValue)"
        }
        setLoadTypeSwitch()
        tv_SartLocation.text = "\(theLoad.loadStart)"
        tv_EndLocation.text = "\(theLoad.loadEnd)"
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func click_Cancel(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        
    }

    @IBAction func click_Update(_ sender: AnyObject) {
        theLoad.loadDescription = tv_Description.text!
        
        //check the value of tv_LoadValue
        if theLoad.loadType == loadTypeEnum.linearUp{
            theLoad.loadValue = 0
            theLoad.loadValue2 = myNums.txtToD(tv_LoadValue.text!)
        }else{
            theLoad.loadValue = myNums.txtToD(tv_LoadValue.text!)
            theLoad.loadValue2 = 0
        }
        //the loadTypeEnum gets set on the switch click functions
        
        theLoad.loadStart = myNums.txtToD(tv_SartLocation.text!)
        theLoad.loadEnd = myNums.txtToD(tv_EndLocation.text!)
        
        if self.delegate != nil{
            delegate?.updateLoad(self.theLoad, indexOfLoad:theLoadIndex)
            self.dismiss(animated: true, completion: nil)
        }
        
        
    }

    @IBAction func click_C(_ sender: AnyObject) {
        theLoad.loadType = loadTypeEnum.concentrated
        setLoadTypeSwitch()
        
        self.tv_EndLocation.text = "\(0)"
    }
    
    @IBAction func click_U(_ sender: AnyObject) {
        theLoad.loadType = loadTypeEnum.uniform
        setLoadTypeSwitch()
        
        self.tv_EndLocation.text = "\(self.theBeam.length)"
    }
    
    @IBAction func click_LUp(_ sender: AnyObject) {
        theLoad.loadType = loadTypeEnum.linearUp
        setLoadTypeSwitch()
         self.tv_EndLocation.text = "\(self.theBeam.length)"
    }
    
    
    @IBAction func click_LD(_ sender: AnyObject) {
        theLoad.loadType = loadTypeEnum.linearDown
        setLoadTypeSwitch()
         self.tv_EndLocation.text = "\(self.theBeam.length)"
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
