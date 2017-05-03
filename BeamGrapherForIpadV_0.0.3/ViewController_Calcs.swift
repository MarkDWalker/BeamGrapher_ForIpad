//
//  ViewController_Calcs.swift
//  BeamGrapherForIpadV_0.0.3
//
//  Created by Mark Walker on 6/21/15.
//  Copyright (c) 2015 Mark Walker. All rights reserved.
//

import UIKit

class ViewController_Calcs: UIViewController, UIDocumentInteractionControllerDelegate {

    @IBOutlet weak var theScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    
    
    
  
    
    
    var loadImageViewCollection:[UIImageView] = [UIImageView]()
    var loadCollection:[MWLoadData] = [MWLoadData]()
    var loadImages:[UIImage] = [UIImage]()
    
    var shearImageViewCollection:[UIImageView] = [UIImageView]()
    var shearImages:[UIImage] = [UIImage]()
    
    var momentImageViewCollection:[UIImageView] = [UIImageView]()
    var momentImages:[UIImage] = [UIImage]()
    
    
    var deflectionImageViewCollection:[UIImageView] = [UIImageView]()
    var deflectionImages:[UIImage] = [UIImage]()
    
    
    var fh:MWTextFormatHelper = MWTextFormatHelper()
    
    var fileName:String = "FirstPDF.pdf"
    var path:String = NSTemporaryDirectory()
    var pdfPathWithFilename:String = ""
    
    
    var documentInteractionController:UIDocumentInteractionController = UIDocumentInteractionController()
    
    @IBAction func click_PDF(_ sender: UIButton) {
        
        pdfPathWithFilename = path + fileName
        let myURL:URL = URL(fileURLWithPath: pdfPathWithFilename)
        
        //this is where I will create the PDF
        print("Create PDF fired!")
        
        let pageSize:CGSize = CGSize(width: 612,height: 792) //612,792 is 8.5x11
        
        
        UIGraphicsBeginPDFContextToFile(pdfPathWithFilename, CGRect.zero, nil)
        
        drawPDFImages(pageSize)
        
        UIGraphicsEndPDFContext()
        //end create the PDF
        
        
        //This will allow open in
        documentInteractionController = UIDocumentInteractionController(url: myURL)
        
        documentInteractionController.delegate = self
        documentInteractionController.uti = "com.adobe.pdf"
        let originRect:CGRect = CGRect(x: sender.frame.origin.x - 530, y: sender.frame.origin.y, width: 10, height: 10)
        documentInteractionController.presentOpenInMenu(from: originRect, in: sender, animated: true)
        //end open in
    }
    
    func drawPDFBackground(_ pageRect:CGRect){
        let context:CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(UIColor.blue.cgColor)
        context.fill(pageRect)
    }
    
    
    func drawPDFImages(_ pageSize:CGSize){
      
        for i:Int in 0 ..< loadImages.count{
            UIGraphicsBeginPDFPageWithInfo(CGRect(x: 0, y: 0, width: pageSize.width, height: pageSize.height), nil)
            let width = loadImages[i].size.width
            let height = loadImages[i].size.height
            let factor:CGFloat = 0.76
            let yLoadViews:CGFloat = 80
            let yShearViews:CGFloat = 80 + height * factor
            let yMomentViews:CGFloat = 80 + (2 * height * factor)
            let yDeflectionViews:CGFloat = 80 + (3 * height * factor)
//            var loadFrame:CGRect = CGRectMake(10, yLoadViews, width, height)
//            var shearFrame:CGRect = CGRectMake(10, yShearViews, width, height)
//            var momentFrame:CGRect = CGRectMake(10, yMomentViews, width, height)
//            var deflectionFrame:CGRect = CGRectMake(10, yDeflectionViews, width, height)
//            
//            loadImageViewCollection[i].frame = loadFrame
//            shearImageViewCollection[i].frame = shearFrame
//            momentImageViewCollection[i].frame = momentFrame
//            deflectionImageViewCollection[i].frame = deflectionFrame
            
            
            let pdfLoadFrame:CGRect = CGRect(x: 25, y: yLoadViews, width: width * factor, height: height * factor)
            let pdfShearFrame:CGRect = CGRect(x: 25, y: yShearViews, width: width * factor, height: height * factor)
            let pdfMomentFrame:CGRect = CGRect(x: 25, y: yMomentViews, width: width * factor, height: height * factor)
            let pdfDeflectionFrame:CGRect = CGRect(x: 25, y: yDeflectionViews, width: width * factor, height: height * factor)
            
            
            loadImages[i].draw(in: pdfLoadFrame)
            shearImages[i].draw(in: pdfShearFrame)
            momentImages[i].draw(in: pdfMomentFrame)
            deflectionImages[i].draw(in: pdfDeflectionFrame)
            
            
            //draw the title text on the first page
            if i == 0{
                let myTextRect:CGRect = CGRect(x: 30, y: yLoadViews - 60, width: 300, height: 100)
                let aString:String = "Beam Grapher Results Report"
                aString.draw(in: myTextRect,withAttributes: nil)
            }
            
            
            //draw the text on top of the load view
            if i != loadImages.count - 1{
                let myTextRect:CGRect = CGRect(x: 300, y: yLoadViews - 20, width: 300, height: 100)
                let aString:String = generateLoadText(i)
                aString.draw(in: myTextRect,withAttributes: nil)
            }else{
                let myTextRect:CGRect = CGRect(x: 300, y: yLoadViews - 20, width: 300, height: 100)
                let aString:String = "All Loads Combined."
                aString.draw(in: myTextRect,withAttributes: nil)
            }
            
            
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.contentView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
        for i:Int in 0 ..< loadImages.count{
            
            let width = loadImages[i].size.width
            let height = loadImages[i].size.height
            
            let yLoadViews:CGFloat = 20.0 + (20 * CGFloat(i)) + (CGFloat(i) * 4 * height)
            let yShearViews:CGFloat = 20.0 + (20 * CGFloat(i)) + height + (CGFloat(i) * 4 * height)
            let yMomentViews:CGFloat = 20.0 + (20 * CGFloat(i)) + (2 * height) + (CGFloat(i) * 4 * height)
            let yDeflectionViews:CGFloat = 20 + (20 * CGFloat(i)) + (3 * height) + (CGFloat(i) * 4 * height)
            
            let xPad:CGFloat = (self.view.frame.size.width - width)/2
            
            let newLoadImageView:UIImageView = UIImageView(frame: CGRect(x: xPad, y: yLoadViews, width: width, height: height))
            let newLoadTextView:UITextView = UITextView(frame: CGRect(x: width-300, y: 0, width: 300, height: 100))
            
            let newShearImageView:UIImageView = UIImageView(frame: CGRect(x: xPad, y: yShearViews, width: width, height: height))
            let newMomentImageView:UIImageView = UIImageView(frame: CGRect(x: xPad, y: yMomentViews, width: width, height: height))
            let newDeflectionImageView:UIImageView = UIImageView(frame: CGRect(x: xPad, y: yDeflectionViews, width: width, height: height))
            
            newLoadTextView.backgroundColor = UIColor.clear
            newLoadImageView.image = loadImages[i]
            newShearImageView.image = shearImages[i]
            newMomentImageView.image = momentImages[i]
            newDeflectionImageView.image = deflectionImages[i]
            
            loadImageViewCollection.append(newLoadImageView)
            shearImageViewCollection.append(newShearImageView)
            momentImageViewCollection.append(newMomentImageView)
            deflectionImageViewCollection.append(newDeflectionImageView)
            
            self.contentView.addSubview(newLoadImageView)
            self.contentView.addSubview(newShearImageView)
            self.contentView.addSubview(newMomentImageView)
            self.contentView.addSubview(newDeflectionImageView)
            
            newLoadImageView.addSubview(newLoadTextView)
            
            if i != loadImages.count - 1{
                newLoadTextView.insertText(generateLoadText(i))
            }

            
            //This changes the height of the content View
                let contentViewHeight:CGFloat = yDeflectionViews + 200
                ///////////Dictionary for the layout constraints
                var myDict = Dictionary<String, UIView>()
                self.contentView.translatesAutoresizingMaskIntoConstraints = false
                myDict["contentView"] = self.contentView
                //myDict["button"] = button
            
                //Layout Constraints
                self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[contentView(>=\(contentViewHeight))]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: myDict))
            //End Change the height of the content View
            
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func generateLoadText(_ loadNumber:Int)->String{
        var theString:String = ""
        
        let i:Int = loadNumber
        
        let description:String = loadCollection[i].loadDescription
        let type:loadTypeEnum  = loadCollection[i].loadType
        let typeString:String = loadCollection[i].loadType.rawValue
        var value:Double = 0
        
        if type == loadTypeEnum.linearUp{
            value = loadCollection[i].loadValue2
        }else{
            value = loadCollection[i].loadValue
        }
        
        var units:String = ""
        if type == loadTypeEnum.concentrated{
            units = "Kips"
        }else{
            units = "Kips per Foot"
        }
        
        let start:Double = loadCollection[i].loadStart
        let end:Double = loadCollection[i].loadEnd
        
        
        print("\(loadCollection.count)")
        print("\(loadCollection[loadNumber].loadType.rawValue)")
        
        theString = theString + "Load Description - \(description)"
        theString = theString + "\n"
        theString = theString + "Load Number - \(loadNumber)"
        theString = theString + "\n"
        theString = theString + "Load Type - \(typeString), \(value) \(units)"
        theString = theString + "\n"
        
//        tView.insertText("Load Description - \(description)")
//        tView.insertText("\n")
//        tView.insertText("Load Number - \(loadNumber)")
//        tView.insertText("\n")
//        tView.insertText("Load Type - \(typeString), \(value) \(units)")
//        tView.insertText("\n")
        
        if type == loadTypeEnum.concentrated{
            theString = theString + "Load Location - \(start) feet"
//        tView.insertText("Load Location - \(start) feet")
        }else{
            theString = theString + "Load Start - \(start) ft., Load End - \(end) ft."
//            tView.insertText("Load Start - \(start) ft., Load End - \(end) ft.")
        }
        
       return theString
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    

}
