import UIKit




class MWBeamGeometry: NSObject{
    var title:String = "B1"
    var length:Double = 10.0  //beam length
    var dataPointCount:Int = 19  //number of data points for the calculation on the beam
    var E:Double = 1600
    var I:Double = 200
    
    override init(){
        
    }
    
    init(theLength:Double, theDataPointCount:Int, theE:Double = 1600, theI:Double = 200){
        length = theLength
        dataPointCount = theDataPointCount
        E = theE
        I = theI
    }
    
}

enum loadTypeEnum:String{
    case concentrated = "Concentrated"
    case uniform = "Uniform"
    case linearUp = "Linear Up"
    case linearDown = "Linear Down"
}

class MWLoadData:NSObject{
    var loadDescription:String = "theload"
    var loadValue:Double = 1
    var loadValue2:Double = 0
    var loadType:loadTypeEnum = .concentrated
    var loadStart:Double = 0.0
    var loadEnd:Double = 0.0
    var graphPointCollection=[CGPoint]()
    //var maxYInGraph:Double = 0
    var beamGeo:MWBeamGeometry = MWBeamGeometry(theLength: 1, theDataPointCount: 1, theE: 1600, theI: 200)
    
    override init(){
        
    }
    
    init(theDescription:String, theLoadValue:Double, theLoadType:loadTypeEnum, theLoadStart:Double, theLoadEnd:Double, theBeamGeo:MWBeamGeometry){
        super.init()
        loadValue = theLoadValue
        loadType = theLoadType
        loadStart = theLoadStart
        loadEnd = theLoadEnd
        beamGeo = theBeamGeo
        
        loadGraphPointCollection(theBeamGeo)
       
        
    } // end init
    
    func getMaxYInGraph()->Double{
        //find the max y graph point value
        var tempMaxY:Double = 0
        for i:Int in 0 ..< graphPointCollection.count{
            if Double(graphPointCollection[i].y) > tempMaxY {
                tempMaxY = Double(graphPointCollection[i].y)
            }//end if
            
        }//end for
        
        return tempMaxY
    }
    
    
    //same as init, but used to add the data after the init
    func addValues(_ theDescription:String, theLoadValue:Double, theLoadType:loadTypeEnum, theLoadStart:Double, theLoadEnd:Double, theBeamGeo:MWBeamGeometry){
        loadDescription = theDescription
        loadValue = theLoadValue
        loadType = theLoadType
        loadStart = theLoadStart
        loadEnd = theLoadEnd
        beamGeo = theBeamGeo
        
        loadGraphPointCollection(theBeamGeo)
        
        
    } // end add values

    
    func loadGraphPointCollection(_ beamGeo:MWBeamGeometry){
        if loadType == .concentrated{
graphPointCollection.removeAll()
            
            let startPoint = CGPoint(x: loadStart, y: loadValue)
            graphPointCollection.append(startPoint)
            let endPoint = CGPoint(x: loadStart, y: 0.00)
            graphPointCollection.append(endPoint)
            
        }else if loadType == .uniform{
graphPointCollection.removeAll()
            let P1 = CGPoint(x: loadStart, y: 0)
            let P2 = CGPoint(x: loadStart, y: loadValue)
            let P3 = CGPoint(x: loadEnd , y: loadValue)
            let P4 = CGPoint(x: loadEnd, y: 0)
            graphPointCollection.append(P1)
            graphPointCollection.append(P2)
            graphPointCollection.append(P3)
            graphPointCollection.append(P4)
            
        }else if loadType == .linearUp || loadType == .linearDown {
         graphPointCollection.removeAll()
            let P1 = CGPoint(x: loadStart, y: 0)
            let P2 = CGPoint(x: loadStart, y: loadValue)
            let P3 = CGPoint(x: loadEnd, y: loadValue2)
            let P4 = CGPoint(x: loadEnd, y: 0)
            graphPointCollection.append(P1)
            graphPointCollection.append(P2)
            graphPointCollection.append(P3)
            graphPointCollection.append(P4)
        }//end if
        
        
    }//end function
    
}//end class

enum calcTypeEnum:String{
    case shear = "shear"
    case moment = "Moment"
    case deflection = "Deflection"
}

class MWStructuralEquations:NSObject{
    
    var BeamGeo:MWBeamGeometry = MWBeamGeometry()
    var Load:MWLoadData = MWLoadData()
    var calcType:calcTypeEnum = .moment
    
    override init(){
        super.init()
    }
    
    func loadEquationValues(_ theCalcType:calcTypeEnum, theLoad:MWLoadData, theBeamGeo:MWBeamGeometry){
        
        BeamGeo = theBeamGeo
        Load = theLoad
        calcType = theCalcType
    }
    
    
    func performCalc(_ location:Double)->Double{
        var returnValue:Double = 0
        
        
        if calcType == .shear && Load.loadType == .uniform{
            returnValue = -uniformLoadShear(location)
            
        }else if calcType == .moment && Load.loadType == .uniform{
            returnValue = uniformLoadMoment(location)
            
        }else if calcType == .deflection && Load.loadType == .uniform{
            returnValue = uniformLoadDeflection(location, E:BeamGeo.E, I: BeamGeo.I)
        
        }else if calcType == .shear && Load.loadType == .concentrated{
            returnValue = -concentratedLoadShear(location)
        
        }else if calcType == .moment && Load.loadType == .concentrated{
            returnValue = concentratedLoadMoment(location)
        
        }else if calcType == .deflection && Load.loadType == .concentrated{
            returnValue = concentratedLoadDeflection(location, E:BeamGeo.E, I: BeamGeo.I)
        
        }else if calcType == .shear && (Load.loadType == .linearUp || Load.loadType == .linearDown){
            returnValue =  -linearLoadShear(location)
        
        }else if calcType == .moment && (Load.loadType == .linearUp || Load.loadType == .linearDown){
        returnValue = linearLoadMoment(location)
       
        }else if calcType == .deflection && (Load.loadType == .linearUp || Load.loadType == .linearDown){
            returnValue = linearLoadDeflection(location, E:BeamGeo.E, I:BeamGeo.I)
        }
        
        return returnValue
    }
    
    
    //////uniform load functions
    func uniformLoadShear(_ location:Double)->Double{
        var returnValue:Double = 0
        let l:Double = BeamGeo.length
        let a:Double = Load.loadStart
        let b:Double = Load.loadEnd - Load.loadStart
        let c:Double = l-Load.loadEnd
        let w:Double = Load.loadValue
        let x:Double = location
        let R1:Double = w*b*(2*c+b)/(2*l)
        let R2:Double = w*b*(2*a+b)/(2*l)
        
        if x<a{
            returnValue = R1
        }else if x>a+b{
            returnValue = -R2
        }else{
            returnValue = R1 - w * (x - a)
        }
        return returnValue
    }
    
    func uniformLoadMoment(_ location:Double)->Double{
        var returnValue:Double = 0
        let l:Double = BeamGeo.length
        let a:Double = Load.loadStart
        let b:Double = Load.loadEnd - Load.loadStart
        let c:Double = l-Load.loadEnd
        let w:Double = Load.loadValue
        let x:Double = location
        let R1:Double = w*b*(2*c+b)/(2*l)
        let R2:Double = w*b*(2*a+b)/(2*l)
        
        if x<a{
            returnValue = R1 * x
        }else if x>a+b{
            returnValue = R2 * (l-x)
        }else{
          returnValue = (R1 * x) - ((w/2) * (x - a) * (x - a))
        }
        
        return returnValue
    }
    
    func uniformLoadDeflection(_ location:Double, E: Double, I:Double)->Double{
        var tempResult:Double = 0
        //_:Double = Load.loadEnd - Load.loadStart
        var tempLoadPos:Double = Load.loadStart
        let stepDistance:Double = 0.001
        let Ifeet:Double = I / (12*12*12*12)
        let Efeet:Double = E * 12 * 12
        
        //set the array of concentrated loads
            
            while tempLoadPos<=Load.loadEnd{
                
                let l:Double=BeamGeo.length
                let a:Double=tempLoadPos
                let b:Double=l-tempLoadPos
                let x:Double=location
                let x2:Double = l-x
                let p:Double=Load.loadValue
                
                
                if x <= tempLoadPos {
                    tempResult = tempResult + stepDistance*p*b*x*(l*l-b*b-x*x)/(6*Efeet*Ifeet*l)
                }else{
                    tempResult = tempResult + stepDistance*p*a*x2*(l*l-a*a-x2*x2)/(6*Efeet*Ifeet*l)
                }// end if
                
                tempLoadPos = tempLoadPos + stepDistance
            } //end while
            
        
        
        let returnValue:Double = tempResult*12  //* 12 to get back to inches
        return returnValue
    }
    ////end uniform load functions
    
    ////Concentrated Load functions
    func concentratedLoadShear(_ location:Double)->Double{
        var returnValue:Double = 0
        let l:Double=BeamGeo.length
        let a:Double=Load.loadStart
        let b:Double=l-Load.loadStart
       // _:Double=location
        let p:Double=Load.loadValue
        
        if location<=Load.loadStart {
            returnValue = p*b/l
        }else{
            returnValue = -p*a/l
        }
        return returnValue
    }
    
    func concentratedLoadMoment(_ location:Double)->Double{
        var returnValue:Double = 0
        let l:Double=BeamGeo.length
        let a:Double=Load.loadStart
        let b:Double=l-Load.loadStart
        let x:Double=location
        let p:Double=Load.loadValue
        if x <= a{
            returnValue = p * b * x / l
        }else{
            returnValue = p * a * (l-x) / l
        }
        return returnValue
    }
    
    func concentratedLoadDeflection(_ location:Double, E: Double, I:Double)->Double{
        var returnValue:Double = 0
        let l:Double = BeamGeo.length
        let x:Double = location
        let x2:Double = l-location
        let a:Double = Load.loadStart
        let b:Double = l-Load.loadStart
        let p:Double = Load.loadValue
        let Ifeet:Double = I / (12*12*12*12)
        let Efeet:Double = E * 12 * 12
        
        if location < Load.loadStart{
            returnValue = 12*p*b*x*(l*l-b*b-x*x)/(6*Efeet*Ifeet*l)
        }else{
            returnValue = 12*p*a*x2*(l*l-a*a-x2*x2)/(6*Efeet*Ifeet*l)
        }
        
        return returnValue
    }
    //// end concentrated load functions
    
    //linear Load functions
    func linearLoadShear(_ location:Double)->Double{
        var tempResult:Double = 0
        let loadLength:Double = Load.loadEnd - Load.loadStart
        let loadMagSlope:Double = ((Load.loadValue2 - Load.loadValue)/loadLength)
        //_;:Double = 1
        var tempLoadMag:Double = Load.loadValue
        var tempLoadPos:Double = Load.loadStart
        let stepDistance:Double = 0.001
    
    
        //set the array of concentrated loads
        if Load.loadValue == 0 { //we know that the load slopes up
            
            while tempLoadPos<=Load.loadEnd{
                
                let l:Double=BeamGeo.length
                let a:Double=tempLoadPos
                let b:Double=l-tempLoadPos
                let x:Double=location
                let p:Double=tempLoadMag
                
                if x <= tempLoadPos {
                    tempResult = tempResult + stepDistance*p*b/l
                }else{
                    tempResult = tempResult - stepDistance*p*a/l
                }// end if
                
                tempLoadPos = tempLoadPos + stepDistance
                tempLoadMag = Load.loadValue + ((tempLoadPos-Load.loadStart) * loadMagSlope)
            } //end while
    
            
            
        }else{ //the load slopes down
    
            
            
            while tempLoadMag>=0{
                
                let l:Double=BeamGeo.length
                let a:Double=tempLoadPos
                let b:Double=l-tempLoadPos
                let x:Double=location
                let p:Double=tempLoadMag
                
                if x<=tempLoadPos {
                    tempResult = tempResult + stepDistance * p * b / l
                }else{
                    tempResult = tempResult - stepDistance * p *  a / l
                }// end if
                
                tempLoadPos = tempLoadPos + stepDistance
                tempLoadMag = Load.loadValue + ((tempLoadPos-Load.loadStart) * loadMagSlope) //the slope should be neg
                
            } //end while
            
        }//end if
        
        
        let returnValue:Double = tempResult
        return returnValue
    }
    
    func linearLoadMoment(_ location:Double)->Double{
        var tempResult:Double = 0
        let loadLength:Double = Load.loadEnd - Load.loadStart
        let loadMagSlope:Double = ((Load.loadValue2 - Load.loadValue)/loadLength)
        var tempLoadMag:Double = Load.loadValue
        var tempLoadPos:Double = Load.loadStart
        let stepDistance:Double = 0.001
        
        
        //set the array of concentrated loads
        if Load.loadValue == 0 { //we know that the load slopes up
            
            while tempLoadPos<=Load.loadEnd{
                
                let l:Double=BeamGeo.length
                let a:Double=tempLoadPos
                let b:Double=l-tempLoadPos
                let x:Double=location
                let p:Double=tempLoadMag
                
                if x <= tempLoadPos {
                    tempResult = tempResult + stepDistance*p*b*x/l
                }else{
                    tempResult = tempResult + stepDistance*p*a*(l-x)/l
                }// end if
                
                tempLoadPos = tempLoadPos + stepDistance
                tempLoadMag = Load.loadValue + ((tempLoadPos-Load.loadStart) * loadMagSlope)
            } //end while
            
            
            
        }else{ //the load slopes down
            
            
            
            while tempLoadMag>=0{
                
                let l:Double=BeamGeo.length
                let a:Double=tempLoadPos
                let b:Double=l-tempLoadPos
                let x:Double=location
                let p:Double=tempLoadMag
                
                if x<=tempLoadPos {
                    tempResult = tempResult + stepDistance * p * b * x / l
                }else{
                    tempResult = tempResult + stepDistance * p *  a * (l-x) / l
                }// end if
                
                tempLoadPos = tempLoadPos + stepDistance
                tempLoadMag = Load.loadValue + ((tempLoadPos-Load.loadStart) * loadMagSlope) //the slope should be neg
                
            } //end while
            
        }//end if
        
        
        let returnValue:Double = tempResult
        return returnValue
    }
    
    func linearLoadDeflection(_ location:Double, E: Double, I:Double)->Double{
        var tempResult:Double = 0
        let loadLength:Double = Load.loadEnd - Load.loadStart
        let loadMagSlope:Double = ((Load.loadValue2 - Load.loadValue)/loadLength)
        var tempLoadMag:Double = Load.loadValue
        var tempLoadPos:Double = Load.loadStart
        let stepDistance:Double = 0.001
        let Ifeet:Double = I / (12*12*12*12)
        let Efeet:Double = E * 12 * 12
        
        //set the array of concentrated loads
        if Load.loadValue == 0 { //we know that the load slopes up
            
            while tempLoadPos<=Load.loadEnd{
                
                let l:Double=BeamGeo.length
                let a:Double=tempLoadPos
                let b:Double=l-tempLoadPos
                let x:Double=location
                let x2:Double = l-x
                let p:Double=tempLoadMag
                
                
                
                if x <= tempLoadPos {
                    tempResult = tempResult + stepDistance*p*b*x*(l*l-b*b-x*x)/(6*Efeet*Ifeet*l)
                }else{
                    tempResult = tempResult + stepDistance*p*a*x2*(l*l-a*a-x2*x2)/(6*Efeet*Ifeet*l)
                }// end if
                
                tempLoadPos = tempLoadPos + stepDistance
                tempLoadMag = Load.loadValue + ((tempLoadPos-Load.loadStart) * loadMagSlope)
            } //end while
            
            
            
        }else{ //the load slopes down
            
            
            
            while tempLoadMag>=0{
                
                let l:Double=BeamGeo.length
                let a:Double=tempLoadPos
                let b:Double=l-tempLoadPos
                let x:Double=location
                let x2:Double = l-x
                let p:Double=tempLoadMag
                
                if x<=tempLoadPos {
                    tempResult = tempResult + stepDistance*p*b*x*(l*l-b*b-x*x)/(6*Efeet*Ifeet*l)
                }else{
                    tempResult = tempResult + stepDistance*p*a*x2*(l*l-a*a-x2*x2)/(6*Efeet*Ifeet*l)
                }// end if
                
                tempLoadPos = tempLoadPos + stepDistance
                tempLoadMag = Load.loadValue + ((tempLoadPos-Load.loadStart) * loadMagSlope) //the slope should be neg
                
            } //end while
            
        }//end if
        
        
        let returnValue:Double = tempResult*12
        return returnValue

    }
    ////end Linear load functions
    
    
    
}//end class




class MWStructuralGraphData: NSObject{
    
    var BeamGeo:MWBeamGeometry = MWBeamGeometry()
    var Load:MWLoadData = MWLoadData()
    var calcType:calcTypeEnum = .moment
    var equations:MWStructuralEquations = MWStructuralEquations()
    var theDataCollection = [CGPoint]()
    
    
    
    override init(){
        
    }
    
    init(theBeamGeo:MWBeamGeometry, theLoad:MWLoadData, theCalcType:calcTypeEnum){
        super.init()
        
        
        BeamGeo = theBeamGeo    //sets value of class var
        Load = theLoad          //sets value of class var
        calcType = theCalcType  //sets value of class var
        
        //loads the initial required values into the equations object when a init() is used
        equations.loadEquationValues(calcType, theLoad:Load, theBeamGeo: BeamGeo)
        
        //loads theDataCollection class var
        loadCalcDataCollection()
        
    }
    
   func update(_ theBeamGeo:MWBeamGeometry, theLoad:MWLoadData, theCalcType:calcTypeEnum){
    
        BeamGeo = theBeamGeo    //sets value of class var
        Load = theLoad          //sets value of class var
        calcType = theCalcType  //sets value of class var
    
        //loads the initial required values into the equations object when a init() is used
        equations.loadEquationValues(calcType, theLoad:Load, theBeamGeo: BeamGeo)
    
        //loads theDataCollection class var
        loadCalcDataCollection()
    
    }
    
    //function loads the acutal x,y values into theDataCollection
    func loadCalcDataCollection(){
        //empties the data collection
        theDataCollection.removeAll()
        
        //find the distance increment
        let increment:Double = BeamGeo.length/(Double(BeamGeo.dataPointCount)-1)
        
        var incCounter:Double = 0.0
        var tempCalcValue:Double = 0.0
        var tempPoint:CGPoint = CGPoint(x: 0, y: 0)
        
        //the following line looks goofy because the .10 added to the length. It is necessary due to the rounding error induced by the use of Double for the counter
        
        for incCounter in stride(from: 0.0, through: BeamGeo.length + 0.01, by:increment){
        //for incCounter = 0.0; incCounter <= (BeamGeo.length + 0.01); incCounter = (incCounter + increment){
            tempCalcValue = equations.performCalc(incCounter)//loadData*incCounter*(beamLength-incCounter)/2  //*****this line calcs moment at increments****//
            
            tempPoint.x = CGFloat(incCounter)
            tempPoint.y = CGFloat(tempCalcValue)
            theDataCollection.append(tempPoint)
        }//end for
    }
    
    func getMaxCalcValues()->(yVal:Double, xVal:Double){
        var i:Int = 0
        var y:Double = Double(abs(theDataCollection[0].y))
        var x:Double = 0
        for i in 0 ..< theDataCollection.count{
            if Double(abs(theDataCollection[i].y))>y{
                y = Double(abs(theDataCollection[i].y))
                x = Double(theDataCollection[i].x)
            }
        }
        
        return (y,x)
    }
    
}//End class


class MWLoadComboResult:NSObject{
    
    var resultsCollection = [MWStructuralGraphData]() //this is the main var that holds the totals and is initially blank
    var graphTotals = MWStructuralGraphData() //this holds the summation of the y items in the results collection to give a total result
    
    override init(){
        
    }
   
    func setGraphTotals(){
        
        var tempValuex:Double = 0
        var tempValuey:Double = 0
        var theDataPoint:CGPoint = CGPoint()
        //empty the collection because we are going to add all the items  again
        graphTotals.theDataCollection.removeAll(keepingCapacity: false)
        for i:Int in 0 ..< graphTotals.BeamGeo.dataPointCount { //Outer loop thru dataPoints
            tempValuex = Double(resultsCollection[0].theDataCollection[i].x)
            for j:Int in 0 ..< resultsCollection.count{ //inner loop thru each collection item
                tempValuey = tempValuey+Double(resultsCollection[j].theDataCollection[i].y)
            }//end inner loop
            
            theDataPoint.x = CGFloat(tempValuex)
            theDataPoint.y = CGFloat(tempValuey)
            graphTotals.theDataCollection.append(theDataPoint)
            tempValuey = 0
        } //end outer loop
        
    } //end function
    
    func clearResultsCollection(){
        self.resultsCollection.removeAll(keepingCapacity: false)
    }
    
    
    func addResult(_ newStructuralGraphData:MWStructuralGraphData){
        
        //if this is the first one, just add it
        if resultsCollection.count == 0 {
            
            resultsCollection.append(newStructuralGraphData)
            
            //set some value of the graphTotals Object
            graphTotals.BeamGeo.length = newStructuralGraphData.BeamGeo.length
            graphTotals.BeamGeo.dataPointCount = newStructuralGraphData.BeamGeo.dataPointCount
            
            setGraphTotals()
            
            //if this is not the first one do some checks
        } else if resultsCollection.count > 0 {
        
        //data in the init graph data
        let beamLength0:Double = resultsCollection[0].BeamGeo.length
        let dataPointCount0:Int = resultsCollection[0].BeamGeo.dataPointCount
        
        //data in the newly added data
        let beamLengthNew = newStructuralGraphData.BeamGeo.length
        let dataPointCountNew = newStructuralGraphData.BeamGeo.dataPointCount
        
            //check that the the new dataset has the same beam length and the same datapoint count
            if beamLength0 == beamLengthNew && dataPointCount0 == dataPointCountNew{
                resultsCollection.append(newStructuralGraphData)
                setGraphTotals()
            
            }else{
                //should throw a flag here
            }//end if
            
        }//end if
        
        
    }//end function
    
  
        
    
    
} //end class
