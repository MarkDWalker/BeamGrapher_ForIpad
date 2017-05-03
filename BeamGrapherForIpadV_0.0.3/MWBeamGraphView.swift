//
//  MWBeamGraphView.swift
//  BeamStory
//
//  Created by Mark Walker on 11/16/14.
//  Copyright (c) 2014 Mark Walker. All rights reserved.
//

import UIKit

class MWBeamGraphView: UIView {
    
    var title:NSString = ""
    var maxUnits:NSString = ""
    var maxX:Double = 1
    var maxY:Double = 1
    var maxYLocation:Double = 1
    var xPad:Int = 1
    var yPad:Int = 1
    
    
    var viewColor = UIColor.white
    var graphColor = UIColor.red
    var graphColorB = UIColor.gray
    var beamColor = UIColor.green
    var graphColorSelected = UIColor.blue

    
    var xPath = UIBezierPath() //path for the x values i.e. the beam
    var yPath = UIBezierPath() //path the y values i.e. the results
    var zPaths = [UIBezierPath]() //a collection of paths for the the results of separate indivigual loads
    var circPaths:[UIBezierPath] = [UIBezierPath]()
    
    
   
    
    var loadComboResult = MWLoadComboResult()
    var selectedLoadIndex:Int = 0
    
    
    
    override func draw(_ dirtyRect: CGRect) {
        //create the rounded corners of the nsview
        let clippedPath:UIBezierPath = UIBezierPath(roundedRect: dirtyRect, cornerRadius: 15)
        clippedPath.addClip()
        
        //draw the view
        self.backgroundColor = UIColor.clear
        viewColor.setFill()
        UIRectFill(self.bounds)
        
         graphColorSelected.set()
        
        for i:Int in 0 ..< circPaths.count{
            //yPath[j].lineWidth = 1
            circPaths[i].stroke()
        }
        
        //draw the results for the indivudual loads
        
        for j:Int in 0 ..< zPaths.count{
            if j==selectedLoadIndex{
                graphColorSelected.set()
            }else{
                graphColorB.set()
            }
            //yPath[j].lineWidth = 1
            zPaths[j].stroke()
        }
        
        //draw the beam
        beamColor.set()
        xPath.lineWidth = 2
        xPath.stroke()
        
        //draw the main results graph
        graphColor.set()
        yPath.stroke()
    }
    
    
    
    //load member vars and does some initialization, do not want to override the NSViews init()
    func loadDataCollection(_ theTitle:NSString,theLoadComboResult:MWLoadComboResult, xPadding:Int, yPadding:Int, optionalMaxUnits:String = ""){
        
        title = theTitle
        maxUnits = optionalMaxUnits as NSString
        loadComboResult = theLoadComboResult
        let tempCount:Int = loadComboResult.graphTotals.theDataCollection.count
        
        self.xPad = xPadding
        self.yPad = yPadding
        
        //get the max x value
        self.maxX = Double(loadComboResult.graphTotals.theDataCollection[tempCount-1].x)
        
        
        // get the max y value
        
        var tempMaxY:Double = Double(abs(loadComboResult.graphTotals.theDataCollection[0].y))
        var tempMaxYLocation:Double = Double(loadComboResult.graphTotals.theDataCollection[0].x)
        
        for i:Int in 0 ..< loadComboResult.graphTotals.theDataCollection.count{
            if Double(abs(loadComboResult.graphTotals.theDataCollection[i].y))>tempMaxY{
                tempMaxY = Double(abs(loadComboResult.graphTotals.theDataCollection[i].y))
                tempMaxYLocation = Double(loadComboResult.graphTotals.theDataCollection[i].x)
            } //end if
            
        }//end for
        self.maxY = tempMaxY
        self.maxYLocation = tempMaxYLocation
        // end get the max y value
        zPaths.removeAll(keepingCapacity: false)
        
        for _:Int in 0 ..< loadComboResult.resultsCollection.count{
            //initialize the correct number of yPath items to nothing
            let newYPathItem:UIBezierPath = UIBezierPath()
            zPaths.append(newYPathItem)
            }
        
        
    }//end function
    
    
    
    func getxScaleFactor()->Double{
        let width:Double = Double(self.frame.size.width)
         print("The width in xScale is \(width)")
        let xscale:Double = ((width) - Double(xPad)) / maxX
        return xscale
    }
    
    func getyScaleFactor()->Double{
        let yscale = ((Double(self.frame.height)/2) - Double(yPad)) / maxY
        return yscale
    }
    
   
    func generateBeamCoords()->[CGPoint]{
        let xScale:Double = getxScaleFactor()
        //_:Double = getyScaleFactor()
        let yAdjustment = Double(self.frame.height)/2
        var beamPoints:[CGPoint] = [CGPoint]()
    
        //get the start of the beam
        let startPoint:CGPoint = CGPoint(x: CGFloat(Double(xPad/2) + (Double(loadComboResult.graphTotals.theDataCollection[0].x) * xScale)), y: CGFloat(yAdjustment))
        beamPoints.append(startPoint)
        
        //get the end of the beam
        let pointCount:Int = loadComboResult.graphTotals.theDataCollection.count - 1
        let endPoint:CGPoint = CGPoint(x: CGFloat(Double(xPad/2) + (Double(loadComboResult.graphTotals.theDataCollection[pointCount].x) * xScale)), y: CGFloat(yAdjustment))
        beamPoints.append(endPoint)
        
        return beamPoints
    }
    
    func generateGraphCoords(_ points:[CGPoint])->[CGPoint]{
        let xScale = Double(getxScaleFactor())
        let yScale = Double(getyScaleFactor())
        let yAdjustment = Double((self.frame.height)/2)
        var mainGraphPoints:[CGPoint] = [CGPoint]()
        
        //preStart point will be at the beginning of the beam
        let preStartPoint:CGPoint = CGPoint(x: CGFloat(Double(xPad/2) + Double(points[0].x) * xScale), y: CGFloat(yAdjustment))
        mainGraphPoints.append(preStartPoint)
        
        
        for i:Int in 0 ..< points.count{
            let tempX:Double = Double(xPad/2)+(Double(points[i].x) * xScale)
            let tempY:Double = Double(points[i].y) * yScale
            /////Change made here!!!!!!! took out negative sign in front of points on line above !!!!!
            let point = CGPoint(x: CGFloat(tempX), y: CGFloat((tempY) + yAdjustment))
            mainGraphPoints.append(point)
        }
        
        let postEndPoint = CGPoint(x: CGFloat(Double(xPad/2) + (Double(points[points.count-1].x) * xScale)), y: CGFloat(yAdjustment))
        mainGraphPoints.append(postEndPoint)
        
        return mainGraphPoints
    }
    
    
    func drawGraphItem(_ points:[CGPoint], theBezierPath:UIBezierPath){
        theBezierPath.removeAllPoints()
        theBezierPath.move(to: points[0])
        
        for i:Int in 1 ..< points.count{
            theBezierPath.addLine(to: points[i])
        }
    }

    func drawAllWithLabelsOn(_ collectionToLabel:[CGPoint], selectedLoadIndex:Int, maxTitleLocation:Bool, totals:Bool){
        
        //set the selected load index
        self.selectedLoadIndex = selectedLoadIndex
        //draw the subgraphs
        
        for i:Int in 0 ..< loadComboResult.resultsCollection.count{
            let subGraphPoints:[CGPoint] = generateGraphCoords(loadComboResult.resultsCollection[i].theDataCollection)
            drawGraphItem(subGraphPoints, theBezierPath: zPaths[i])
        }
        
        //draws the beam
        let beamPoints:[CGPoint] = generateBeamCoords()
        drawGraphItem(beamPoints, theBezierPath: xPath) //Lets see if this works
        
        //draws the Main Graph
        let graphPoints:[CGPoint] = generateGraphCoords(loadComboResult.graphTotals.theDataCollection)
        drawGraphItem(graphPoints, theBezierPath: yPath)
        
        //remove all of the subviews
        
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
        
        //add the title back
        drawTitle(selectedLoadIndex, totals: totals)
        
        //add the labels to the chosen graph
        drawLabels(collectionToLabel)
    }
    
    func drawTitle(_ loadIndex:Int, totals:Bool){
        let
        titleLabel:UITextField = UITextField(frame:CGRect(x: 10, y: 0, width: 500, height: 30))
        titleLabel.font = UIFont.boldSystemFont(ofSize: 13)
        titleLabel.backgroundColor = UIColor.clear
        
        if totals == false && loadIndex >= 0 && loadIndex < self.loadComboResult.resultsCollection.count{
        
            let maxXSelectedLoad:Double = self.loadComboResult.resultsCollection[loadIndex].getMaxCalcValues().xVal
            let maxYSelectedLoad:Double = self.loadComboResult.resultsCollection[loadIndex].getMaxCalcValues().yVal
            
            let firstString:String = (title as String) + " - Max = " + (NSString(format: "%.2f", maxYSelectedLoad) as String) + " " + (maxUnits as String)
            let secondString:String =  " --- @" + ((NSString(format:"%.2f",maxXSelectedLoad)) as String) + " feet"
            titleLabel.text = firstString + secondString
        }else{
            let firstString:String = (title as String) + " - Max = " + (NSString(format: "%.2f", maxY) as String) + " " + (maxUnits as String)
            let secondString:String =  " --- @" + ((NSString(format:"%.2f",maxYLocation)) as String) + " feet"
            titleLabel.text = firstString + secondString
        }
        
        self.addSubview(titleLabel)
        let theString:NSString = titleLabel.text! as NSString
        let charCount:Int = theString.length
        let newRect = CGRect(x: 10, y: 0, width: CGFloat(charCount) * 10, height: 30)
        titleLabel.frame = newRect
    }
    
    
    func drawLabels(_ points:[CGPoint]){
        let xScale = Double(getxScaleFactor())
        let yScale = Double(getyScaleFactor())
        let yAdjustment = Double((self.frame.height)/2)
        var labelSpread:Int = 1
        
        circPaths.removeAll(keepingCapacity: false)
        
        
        for i:Int in 0 ..< points.count{
        //draw the label
            
            if points.count < 6 {
                labelSpread  = 1
            }else{
            labelSpread = points.count/6
            }
            
            
            
            if  i%labelSpread == 0{
                
                //set the original point for the text values
                let originalP = CGPoint(x: points[i].x, y: points[i].y)
                
                //set the adjusted points for the label locations
                let tempX:Double = Double(xPad/2)+(Double(points[i].x) * xScale)
                let tempY:Double = Double(points[i].y) * yScale
                //adjusted above line took our negative sign//
                var adjustP = CGPoint(x: CGFloat(tempX), y: CGFloat((tempY) + yAdjustment))
                
                //the next line is for circle at the points
                if i >= 0 && i < points.count{
                   // _:CGRect = CGRectMake(adjustP.x-2.5, adjustP.y-2.5, 5, 5)
                    let circlePath:UIBezierPath = UIBezierPath()
                    
    
                    circlePath.addArc(withCenter: adjustP, radius: 2.5, startAngle: 0, endAngle: 360, clockwise: true)
                    //circlePath.appendBezierPathWithOvalInRect(rect)
                    circPaths.append(circlePath)
                }
                
                //if it is the last label make an x adjustment so that the label appear on the control
                if i == points.count-1{
                    adjustP.x = adjustP.x - CGFloat(60)
                    
                    if originalP.y <= 0{
                        adjustP.y = adjustP.y - CGFloat(10)
                    }else{
                        adjustP.y = adjustP.y + CGFloat(20)
                    }
                }
                
                //create and add the label
                let theLabel:UITextField = UITextField(frame: CGRect(x: adjustP.x, y: adjustP.y, width: 70, height: 17))
                //theLabel.drawsBackground = false
                let xString = NSString(format: "%.2f", Double(originalP.x))
                let yString = NSString(format: "%.2f", Double(originalP.y))
                theLabel.text = (xString as String) + ", " + (yString as String)
                theLabel.font = UIFont(name: "Verdana", size: 8)
                self.addSubview(theLabel)
            
            }//end if
        }//end for
        
    }//end function
    
    
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
    
   
    
    
    
}// end of class
