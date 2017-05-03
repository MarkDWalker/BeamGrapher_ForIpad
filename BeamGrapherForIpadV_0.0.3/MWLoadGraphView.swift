//
//  MWLoadGraphView.swift
//  BeamStory
//
//  Created by Mark Walker on 11/16/14.
//  Copyright (c) 2014 Mark Walker. All rights reserved.
//

import UIKit


class MWLoadGraphView: UIView {
    var viewColor = UIColor.white
    var graphColor = UIColor.green
    var beamColor = UIColor.black
    var beamFillColor = UIColor.red
    var loadFillColor = UIColor.brown
    var borderColor = UIColor.lightGray
    var selectedLoadColor = UIColor.blue
    var loadBorderColor = UIColor.black
    
    var xPath = UIBezierPath() //path for the x values
    var yPath = [UIBezierPath]() //path the y values
    var bPath = UIBezierPath()
    
    var title:NSString = ""
    var length:NSString = ""
    var E:NSString = ""
    var I: NSString = ""

    var loadCollection = [MWLoadData]()
    var maxX:Double = 1
    var maxY:Double = 1
    var xPad:Int = 1
    var yPad:Int = 1
    var beamThickness:Double = 8
    
    var selectedLoadIndex:Int = 0
    
    
    override func draw(_ dirtyRect: CGRect) {
    
        //create the rounded corners of the nsview
        let clippedPath:UIBezierPath = UIBezierPath(roundedRect: dirtyRect, cornerRadius: 15)
        clippedPath.addClip()
        
        //draw the view
        self.backgroundColor = UIColor.clear
        viewColor.setFill()
        UIRectFill(self.bounds)
        
        
        borderColor.set()
        //bPath.lineWidth = 4
        bPath.stroke()
      
        
        for j:Int in 0 ..< yPath.count{
            
            if j == selectedLoadIndex{
                loadBorderColor.set()
                selectedLoadColor.setFill()
                
            }else{
                loadBorderColor.set()
                loadFillColor.setFill()
                            }
            
            yPath[j].lineWidth = 1.5
            yPath[j].stroke()
            yPath[j].fill()
        }
        
        
        
        beamColor.set()
        xPath.lineWidth = 2
        xPath.stroke()
        UIColor.lightGray.setFill()
        xPath.fill()
        
    }
    
    func loadDataCollection(_ theBeam:MWBeamGeometry, theLoadCollection:[MWLoadData], xPadding:Int, yPadding:Int){
        
        
        
        title = theBeam.title as NSString
        length = NSString(format:"%.2f",theBeam.length)
        E = NSString(format:"%.2f",theBeam.E)
        I = NSString(format:"%.2f",theBeam.I)
        
        loadCollection = theLoadCollection
        //_:Int = loadCollection.count //the number of loads applied
        
        self.xPad = xPadding
        self.yPad = yPadding
        
        //get the max x value
        self.maxX = Double(loadCollection[0].beamGeo.length)
        //end get max x value
        
        
        // get the max y value which is the sum of the y values of the loads
        var tempY:Double = 0
        yPath.removeAll(keepingCapacity: false)
        
        for j in 0 ..< loadCollection.count{
            tempY = tempY + loadCollection[j].getMaxYInGraph()
            
            //initialize the correct number of yPath items to nothing
            let newYPathItem:UIBezierPath = UIBezierPath()
            yPath.append(newYPathItem)
        }
        
        self.maxY = tempY
        // end get the max y value which is the sum of the y values of the loads
        
    }//end function
    
    func drawGraphs(_ selectedLoadIndex:Int){
        
        self.selectedLoadIndex = selectedLoadIndex
        var previousLoadsYSum:Double = 0
    
        
        //draw the beam
        drawBeam(loadCollection[0].graphPointCollection)
        
        
        for i:Int in 0 ..< loadCollection.count{
            drawGraph(loadCollection[i].graphPointCollection, thePrevLoadsYs: previousLoadsYSum, thei:i)
            previousLoadsYSum = previousLoadsYSum + loadCollection[i].getMaxYInGraph()
        }//end for
        
        drawTitle()
    }
    
    func drawBeam(_ dataCollection:[CGPoint]){
        let Xscale:Double = getxScaleFactor()
        //_:Double = getyScaleFactor()
        let yAdjustment:Double = Double(self.frame.height)/2// + thePrevLoadsYs
        
        xPath.removeAllPoints()
        
        //draw the beam
        let P1:CGPoint = CGPoint(x: Double(xPad/2), y: yAdjustment-(beamThickness/2))
        let P2:CGPoint = CGPoint(x: Double(xPad/2), y: yAdjustment+(beamThickness/2))
        let P3:CGPoint = CGPoint(x: Double(xPad/2) + (loadCollection[loadCollection.count-1].beamGeo.length * Xscale), y: yAdjustment+(beamThickness/2))
        let P4:CGPoint = CGPoint(x: Double(xPad/2) + (loadCollection[loadCollection.count-1].beamGeo.length * Xscale), y: yAdjustment-(beamThickness/2))
        xPath.move(to: P1)
        xPath.addLine(to: P2)
        xPath.addLine(to: P3)
        xPath.addLine(to: P4)
        xPath.close()
        
        //draw the beam end
    }
    
    func drawGraph(_ dataCollection:[CGPoint], thePrevLoadsYs:Double, thei:Int){
        let Xscale:Double = getxScaleFactor()
        let Yscale:Double = getyScaleFactor()
        
        let yAdjustment:Double = Double(self.frame.height)/2 - (beamThickness/2)// 8 is for the beam width
        
        
        //xPath.removeAllPoints()
        yPath[thei].removeAllPoints()
        
        
        let startPointLoad:CGPoint = CGPoint(x: Double(xPad/2) + (Double(dataCollection[0].x) * Xscale), y: yAdjustment - thePrevLoadsYs*Yscale)
        
        
        //draw the load
        yPath[thei].move(to: startPointLoad)
        for i in 0 ..< dataCollection.count{
            let xVal:Double = Double(xPad/2) + (Double(dataCollection[i].x) * Xscale)
            //var yVal:Double = (Double(dataCollection[i].y)*Yscale) - yAdjustment - (thePrevLoadsYs * Yscale)
            let yVal:Double = yAdjustment - (thePrevLoadsYs * Yscale) - (Double(dataCollection[i].y)*Yscale)
            let yPoints = CGPoint(x: CGFloat(xVal),y: CGFloat(yVal))
            
            
            if i == 0{
                yPath[thei].addLine(to: yPoints)
                
            }else if i == dataCollection.count-1{
                yPath[thei].addLine(to: yPoints)
            }else{
                
                yPath[thei].addLine(to: yPoints)
                
            }//end if
            
        }//end for
        
        //do some special things for different load types
        if loadCollection[thei].loadType == loadTypeEnum.uniform || loadCollection[thei].loadType == loadTypeEnum.linearUp || loadCollection[thei].loadType == loadTypeEnum.linearDown{
            
        yPath[thei].close()//close the shape for the uniform loads
            
        }else if loadCollection[thei].loadType == loadTypeEnum.concentrated{
            let xTemp:Double = Double(xPad/2) + (Double(dataCollection[1].x) * Xscale) - 10
            let yTemp:Double = (Double(dataCollection[1].y)*Yscale) + yAdjustment - (thePrevLoadsYs * Yscale) - 10
            let ptTemp:CGPoint = CGPoint(x: xTemp, y: yTemp)
            yPath[thei].move(to: ptTemp)
            
            let xTemp2:Double = Double(xPad/2) + (Double(dataCollection[1].x) * Xscale)
            let yTemp2:Double = (Double(dataCollection[1].y)*Yscale) + yAdjustment - (thePrevLoadsYs * Yscale)
            let ptTemp2:CGPoint = CGPoint(x: xTemp2, y: yTemp2)
            yPath[thei].addLine(to: ptTemp2)
            
            let xTemp3:Double = Double(xPad/2) + (Double(dataCollection[1].x) * Xscale) + 10
            let yTemp3:Double = (Double(dataCollection[1].y)*Yscale) + yAdjustment - (thePrevLoadsYs * Yscale) - 10
            let ptTemp3:CGPoint = CGPoint(x: xTemp3, y: yTemp3)
            yPath[thei].addLine(to: ptTemp3)
        }
        
    }//end function
    
    
    
    func drawTitle(){
        
        //remove all of the subviews
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
        
        let titleLabel:UITextField = UITextField(frame:CGRect(x: 10, y: 0, width: self.frame.width - 20, height: 30))
        //titleLabel.font = UIFont(name: "Arial Bold", size: 12)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 13)
        titleLabel.backgroundColor = UIColor.clear
        
        let titleString1:String = (title as String) + ":  L= "
        let titleString2:String = (length as String) + ",  E= " + (E as String) + ",  I=" + (I as String)

        titleLabel.text = titleString1 + titleString2
        self.addSubview(titleLabel)
        
    }
    
    
    func drawLabels(_ originalP:CGPoint, adjustP:CGPoint){
        
        let theLabel:UITextField = UITextField(frame: CGRect(x: adjustP.x, y: adjustP.y, width: 70, height: 17))
        //theLabel.drawsBackground = false
        let xString = String(format: "%.2f", Double(originalP.x))
        let yString = String(format: "%.2f", Double(originalP.y))
        theLabel.text = xString + ", " + yString
        theLabel.font = UIFont(name: "Verdana", size: 8)
        self.addSubview(theLabel)
    }
    
    func getxScaleFactor()->Double{
        var returnValue:Double = 1.0
        let width:Double = Double(self.frame.width)
        let xscale:Double = ((width) - Double(xPad)) / maxX
        returnValue = xscale
        return returnValue
    }
    
    func getyScaleFactor()->Double{
        var returnValue:Double = 1.0
        let yscale = ((Double(self.frame.height)/2) - Double(yPad)) / maxY
        returnValue = yscale
        return returnValue
    }
    
    func getSnapshot() -> UIImage {
        
        let width:CGFloat = self.frame.size.width
        let height:CGFloat = self.frame.size.height
        let myScale:CGFloat = 1
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, UIScreen.main.scale)
        drawHierarchy(in: CGRect(x: 0, y: 0, width: width * myScale, height: height * myScale), afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func getLoadSnapShots()-> [UIImage]{
        var theImages:[UIImage] = [UIImage]()
        let loadIndexToRestoreUponCompletion:Int = selectedLoadIndex
        
        
        for i:Int in 0 ..< loadCollection.count{
            selectedLoadIndex = i
            self.drawGraphs(selectedLoadIndex)
            self.setNeedsDisplay()
            theImages.append(self.getSnapshot())
        }
        
        //add the last image for all of the loads 
        selectedLoadIndex = -1
        self.drawGraphs(selectedLoadIndex)
        self.setNeedsDisplay()
        theImages.append(self.getSnapshot())
        
        //restore the data and control pre function call settings
        selectedLoadIndex = loadIndexToRestoreUponCompletion
        self.drawGraphs(selectedLoadIndex)
        self.setNeedsDisplay()
        
        return theImages
        
    }
    
    
}// end of class
//////////////////////////////////working on this to draw the loads
