//
//  ViewController_DataGrid.swift
//  BeamGrapherForIpadV_0.0.3
//
//  Created by Mark Walker on 6/18/15.
//  Copyright (c) 2015 Mark Walker. All rights reserved.
//

import UIKit

class ViewController_DataGrid: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var theTable: UITableView!
    
    @IBOutlet weak var back: UIButton!
    var gridData:[CGPoint] = [CGPoint]()
    var gridTitle:String = "Nothing"
    
    var lengthUnits:String = ""
    var valueUnits:String = ""
    
    @IBAction func click_Back(_ sender: UIButton) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return gridTitle
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(gridData.count+1)
//        var heightFactor:CGFloat = CGFloat(gridData.count + 1) * 100
//        self.theTable.contentSize.height = heightFactor
        return gridData.count + 1
    
        
    }
    
    func  tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let theRow:Int = indexPath.row
        
    
        
        if theRow == 0{
            
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath) as! CustomCell_TabularHeader
            
            return headerCell
            
        }else{
            
             let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell_GridData
            
            cell.Label1!.text = (NSString(format:"%.2f", gridData[theRow-1].x) as String) + " " + lengthUnits
            cell.Label2!.text = (NSString(format:"%.2f", gridData[theRow-1].y) as String) + " " + valueUnits
  
         return cell
            
        }
        
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //theTable.setNeedsDisplay()
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
