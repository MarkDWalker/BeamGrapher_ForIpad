//
//  MasterViewController.swift
//  BeamGrapherForIpadV_0.0.3
//
//  Created by Mark Walker on 6/6/15.
//  Copyright (c) 2015 Mark Walker. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


class MasterViewController: UITableViewController, MyCellDelegator, MyEditBeamGeoDelegator, MyEditLoadDelegator  {
    
    //MARK: - PUBLIC VARIABLES
    @IBOutlet var theTable: UITableView!
    @IBOutlet weak var theAnchor: UIBarButtonItem!
    
    var detailViewController: DetailViewController? //= nil
    var objects = [AnyObject]()

    
    //for the beam
    var BeamGeo:MWBeamGeometry = MWBeamGeometry(theLength: 10, theDataPointCount: 99, theE: 1600, theI: 200)
    
    //for the loads
    var cLoad:MWLoadData = MWLoadData()
    var loadCollection = [MWLoadData]()
    
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        self.detailViewController?.updateGraphs()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.clearsSelectionOnViewWillAppear = false
        self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //this should hide the anchor. I need to anchor for the custom tableview cell segues
        theAnchor.isEnabled = false
        theAnchor.title = ""
        
        
        let controllers = self.splitViewController!.viewControllers
        let detailNavController = controllers[controllers.count-1] as? UINavigationController
        self.detailViewController = detailNavController?.topViewController as? DetailViewController
        
        
        //add the initial values to the load - cLoad
        cLoad.addValues("L1", theLoadValue: 2, theLoadType: .concentrated, theLoadStart: 3, theLoadEnd: 0, theBeamGeo: BeamGeo)
        
        //add cLoad to the load Collection
        loadCollection.append(cLoad)
        
        
        
        detailViewController?.beam = self.BeamGeo
        detailViewController?.loadCollection = self.loadCollection
        
        //select a row in the table to avoid an error
        let indexPath = IndexPath(row: 0, section:1)
        theTable.selectRow(at: indexPath, animated: true, scrollPosition: UITableViewScrollPosition.top)
        
       
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func click_AddLoad(_ sender: UIBarButtonItem) {
        let newLoad:MWLoadData = MWLoadData(theDescription: "NewLoad", theLoadValue: 2, theLoadType: loadTypeEnum.concentrated, theLoadStart: 1, theLoadEnd: 0, theBeamGeo: BeamGeo)
        
        loadCollection.append(newLoad)
        
        theTable.reloadData()
        
        detailViewController?.loadCollection = self.loadCollection
        
        detailViewController?.updateGraphs()
        
    }

    @IBAction func click_DeleteLoad(_ sender: UIBarButtonItem) {
        var tempLoadCollection:[MWLoadData] = [MWLoadData]()
        
        let loadCountBeforeDelete:Int = loadCollection.count
        
        if loadCountBeforeDelete > 1{
            tempLoadCollection = self.loadCollection
            
            //get the selected row index
            let selectedIndexPath = theTable.indexPathForSelectedRow
            
            if selectedIndexPath != nil{
                tempLoadCollection.remove(at: selectedIndexPath!.row)
                
            }
            
            self.loadCollection = tempLoadCollection
            detailViewController?.loadCollection = self.loadCollection
            detailViewController?.updateGraphs()
            
            theTable.reloadData()
        } else{
            let alertController = UIAlertController(title: "Detele Error", message: "must have at least one (1) load!", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: .cancel) {(action) in
                self.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
//    func insertNewObject(sender: AnyObject) {
//        objects.insert(NSDate(), atIndex: 0)
//        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
//        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
//    }
    
    
    
    
    @IBAction func click_LoadUp(_ sender: AnyObject) {
        
        var tempLoadCollection:[MWLoadData] = [MWLoadData]()
        
        //get the selected row index
        let selectedIndexPath = theTable.indexPathForSelectedRow
            
        if selectedIndexPath?.section == 1 && selectedIndexPath?.row == 0 {
            //don't do anything
            
        }else if selectedIndexPath?.section == 1 && selectedIndexPath?.row > 0 && selectedIndexPath?.row < loadCollection.count{
            let originalIndex = selectedIndexPath?.row
            let newIndex:Int? = originalIndex! - 1
            
            
            //copy the items up to the change
            
            for i:Int in 0  ..< (newIndex!){
                tempLoadCollection.append(self.loadCollection[i])
            }
            
            //them swap the two values
            tempLoadCollection.append(self.loadCollection[originalIndex!])
            tempLoadCollection.append(self.loadCollection[newIndex!])
            
            //now add the rest of the items
            
            for j:Int in (originalIndex! + 1) ..< self.loadCollection.count{
                tempLoadCollection.append(self.loadCollection[j])
            }
            
            self.loadCollection = tempLoadCollection
           detailViewController?.loadCollection = self.loadCollection
            detailViewController?.updateGraphs()
            self.theTable.reloadData()
            
        }else{
            //an error - probably equals nil
            
            
        }
        
        
        
        
    }
    
    

    @IBAction func click_LoadDown(_ sender: AnyObject) {
        var tempLoadCollection:[MWLoadData] = [MWLoadData]()
        
        //get the selected row index
        let selectedIndexPath = theTable.indexPathForSelectedRow
      
        
        if selectedIndexPath?.section == 1 && selectedIndexPath?.row >= self.loadCollection.count - 1 {
            //don't do anything
            
        }else if selectedIndexPath?.section == 1 && selectedIndexPath?.row < self.loadCollection.count && selectedIndexPath?.row >= 0{
            let originalIndex = selectedIndexPath?.row
            let newIndex:Int? = originalIndex! + 1
            
            
            //copy the items up to the change
            
            for i:Int in 0 ... (originalIndex! - 1){
                tempLoadCollection.append(self.loadCollection[i])
            }
            
            //them swap the two values
            tempLoadCollection.append(self.loadCollection[newIndex!])
            tempLoadCollection.append(self.loadCollection[originalIndex!])
            
            //now add the rest of the items
            
            for j:Int in newIndex! + 1 ..< self.loadCollection.count{
                tempLoadCollection.append(self.loadCollection[j])
            }
            
            self.loadCollection = tempLoadCollection
            detailViewController?.loadCollection = self.loadCollection
            detailViewController?.updateGraphs()
            self.theTable.reloadData()
            
        }else{
            //an error - probably equals nil
            
            
        }
    }
    

    @IBAction func click_Refresh(_ sender: UIBarButtonItem) {
        
        detailViewController?.updateGraphs()
    }
    
    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row] as! Date
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object as AnyObject
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }else if segue.identifier == "xxx" {
            
            _ = (segue.destination as! ViewController_EditBeam)
            
           //popController.presentPopoverFromRect(CGRectMake(0, 0, 20, 20), inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
            
           //popController.presentPopoverFromBarButtonItem(but_EditBeam, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: false)
            
            
        }else if segue.identifier == "EditBeam"{
        
            let VC_EditBeam: ViewController_EditBeam = self.storyboard?.instantiateViewController(withIdentifier: "EditBeam") as! ViewController_EditBeam
            VC_EditBeam.delegate = self
            VC_EditBeam.beamGeo = self.BeamGeo
            
            
            
            let popController:UIPopoverController = UIPopoverController(contentViewController: VC_EditBeam)
            
            
            print("The height is \((sender! as AnyObject).frame.height)")
            print("The width is \((sender! as AnyObject).frame.width)")
            let size:CGSize = CGSize(width: 400,height: 300)
            popController.contentSize = size;
            
            var f:CGRect = (sender as! UIButton).frame
            f.origin.x = f.origin.x - 90
            f.origin.y = f.origin.y - 10
            
            popController.present(from: f, in: (sender as! UIButton), permittedArrowDirections: UIPopoverArrowDirection.any, animated: true)
        
        }else if segue.identifier == "EditLoad"{
            
            let VC_EditLoad: ViewController_EditLoad = self.storyboard?.instantiateViewController(withIdentifier: "EditLoad") as! ViewController_EditLoad
            let popController:UIPopoverController = UIPopoverController(contentViewController: VC_EditLoad)
           
            let buttonPosition = (sender as AnyObject).convert(CGPoint.zero, to:theTable)
            let selectedTableRowIndexPath = theTable.indexPathForRow(at: buttonPosition)
            
            if selectedTableRowIndexPath != nil{
                VC_EditLoad.theLoad = self.loadCollection[selectedTableRowIndexPath!.row]
                VC_EditLoad.theLoadIndex = selectedTableRowIndexPath!.row
                VC_EditLoad.theBeam = self.BeamGeo
                VC_EditLoad.delegate = self
                //adjust the size and location of the popover
                let size:CGSize = CGSize(width: 400,height: 350)
                popController.contentSize = size;
                var theFrame = (sender! as AnyObject).frame
                theFrame?.origin.x = 10
                //end adjust
                
                popController.present(from: theFrame!, in: (sender as! UIButton), permittedArrowDirections: UIPopoverArrowDirection.any, animated: true)
                
            }else{
                //produce an error
            }
            
        }
    }
    

    // MARK: - Table View
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
        if indexPath.section == 1 {
            detailViewController?.selectedLoadIndex = indexPath.row
        }
        
        if indexPath.section == 1{// && detailViewController?.segControl.selectedSegmentIndex == 1{
            detailViewController?.updateGraphs()
        }
        
        print("selected section and row = \(indexPath.section) , \(indexPath.row)")
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var theRowCount:Int = 0
        if section == 0{
            theRowCount = 6
        }else if section == 1{
            theRowCount = self.loadCollection.count
        }
        
        return theRowCount
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title:String = ""
        if section == 0{
            title = "BEAM DATA"
        }else if section == 1{
            title = "LOAD LIST"
        }
        return title
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let theSection:Int = indexPath.section
        let theRow:Int = indexPath.row
        
        if theSection == 0 && theRow >= 0 && theRow <= 4{
            let cell = tableView.dequeueReusableCell(withIdentifier: "beamCell", for: indexPath) as! CustomCell_BeamData
            
            if indexPath.row == 0 {
                cell.label_Description!.text = "Description:"
                cell.label_Value.text = BeamGeo.title
                cell.label_Units!.text = ""
            }else if indexPath.row == 1 {
                cell.label_Description!.text = "Beam Length:"
                cell.label_Value.text = "\(BeamGeo.length)"
                cell.label_Units!.text = "Ft."
            } else if indexPath.row == 2{
                cell.label_Description!.text = "No. of Data Pts.:"
                cell.label_Value.text = "\(BeamGeo.dataPointCount)"
                cell.label_Units!.text = ""
            }else if indexPath.row == 3{
                cell.label_Description!.text = "Modulus of Elasticity (E):"
                cell.label_Value.text = "\(BeamGeo.E)"
                cell.label_Units!.text = "KSI"
            }else if indexPath.row == 4{
                cell.label_Description!.text = "Moment of Inertia (I):"
                cell.label_Value.text = "\(BeamGeo.I)"
                cell.label_Units!.text = "In^4"
            }
          
            return cell
            
        }else if theSection == 0 && theRow == 5{
                let cell = tableView.dequeueReusableCell(withIdentifier: "beamEditCell", for: indexPath) as! CustomCell_EditBeam
                cell.delegate = self
                return cell
            
            
        }else {
            let loadCell = tableView.dequeueReusableCell(withIdentifier: "loadCell", for: indexPath) as! CustomCell_LoadData
            loadCell.delegate = self
            
            
                
                loadCell.loadDescription!.text = self.loadCollection[indexPath.row].loadDescription
                loadCell.loadType!.text = self.loadCollection[indexPath.row].loadType.rawValue
            
            if loadCollection[indexPath.row].loadType == loadTypeEnum.linearUp{
                loadCell.loadValue!.text = "\(self.loadCollection[indexPath.row].loadValue2) kips"
            }else{
                loadCell.loadValue!.text = "\(self.loadCollection[indexPath.row].loadValue) kips"
            }
        
            return loadCell
            
        }
       
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

    @IBAction func click_Button(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "EditBeam", sender:sender)
    }
    
    
    
    
    //protocol Function for Edit Beam Segue
    func callSegueFromCell(_ theSender: AnyObject, theSegueIdentifier:String){
        //try not to send self, just to avoid retain cycles(depends on how you handle the code on the next controller)
        self.performSegue(withIdentifier: theSegueIdentifier, sender:theSender)
    }
    
    //protocol Function for Edit Beam popover
    func updateBeamGeo(_ beam:MWBeamGeometry){
        self.BeamGeo.title = beam.title
        self.BeamGeo.length = beam.length
        self.BeamGeo.dataPointCount = beam.dataPointCount
        self.BeamGeo.E = beam.E
        self.BeamGeo.I = beam.I
        
        theTable.reloadData()
        
        //update the beamdata in the detailView
        detailViewController?.beam = self.BeamGeo
        
        //check the loads for any need to update
        
        for j:Int in 0 ..< loadCollection.count{
           
            loadCollection[j] = checkAndModifyLoadAgainstBeamGeo(loadCollection[j])
        } //end for
        
        
        //update the loads with the new beam data
        
        for i:Int in 0 ..< loadCollection.count{
            loadCollection[i].loadGraphPointCollection(self.BeamGeo)
        } //end for
        
        detailViewController?.loadCollection = self.loadCollection
        
        detailViewController?.updateGraphs()
    }
    
    func updateLoad(_ load: MWLoadData, indexOfLoad:Int) {
    
        let returnLoad:MWLoadData = checkAndModifyLoadAgainstBeamGeo(load)
        
        self.loadCollection[indexOfLoad] = returnLoad
        
        //update the load with the new beam data
        loadCollection[indexOfLoad].loadGraphPointCollection(self.BeamGeo)
        
        detailViewController?.updateGraphs()
        theTable.reloadData()
        
    }
    
    
    func checkAndModifyLoadAgainstBeamGeo(_ theLoad:MWLoadData)->MWLoadData{
        
        
        if theLoad.loadType == loadTypeEnum.concentrated{
            if theLoad.loadStart > self.BeamGeo.length{
                theLoad.loadStart = self.BeamGeo.length - 0.10
            }
        }else{
            if theLoad.loadStart > self.BeamGeo.length{
                theLoad.loadStart = self.BeamGeo.length - 1.0
                theLoad.loadEnd = self.BeamGeo.length
            }else if theLoad.loadStart < self.BeamGeo.length && theLoad.loadEnd > self.BeamGeo.length{
                theLoad.loadEnd = self.BeamGeo.length
            }
        }//end if
        
        return theLoad
    }//end function
    
    
    
    

} //end class





