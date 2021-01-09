//
//  TableViewController.swift
//  Assignment2
//
//  Created by Xcode User on 2020-11-26.
//  Copyright © 2020 Xcode User. All rights reserved.
//

import UIKit
import WatchConnectivity

class TableViewController: UITableViewController, WCSessionDelegate {
    var programs : [ProgramObject] = []
    var lastMessage : CFAbsoluteTime = 0
    let getData = GetData()
    var timer : Timer!
    @IBOutlet var myTable : UITableView!
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        
        var replyValues = Dictionary<String, AnyObject>()
        
        
        if (message["getProgData"] != nil)
        {
            // step 8b - serialize and send the fake data to the watch for display
            // note line of code below needed to prevent app crash.
            NSKeyedArchiver.setClassName("ProgramObject", for: ProgramObject.self)
            let programData = NSKeyedArchiver.archivedData(withRootObject: getData.dbData )
            
            replyValues["progData"] = programData as AnyObject?
            replyHandler(replyValues)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.timer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(self.refreshTable), userInfo: nil, repeats: true);
        
        getData.jsonParser()
    }
    
    
    @objc func refreshTable(){
        if(getData.dbData != nil)
        {
            if (getData.dbData?.count)! > 0
            {
                self.myTable.reloadData()
                self.timer.invalidate()
            }
        }
    }
    func initWithDetails()
    {
        
        let programData = NSKeyedArchiver.archivedData(withRootObject: getData.dbData)
        sendWatchMessage(programData)
    }
    
    func sendWatchMessage(_ msgData:Data) {
        let currentTime = CFAbsoluteTimeGetCurrent()
        

        if lastMessage + 0.5 > currentTime {
            return
        }

        if (WCSession.default.isReachable) {

            let programData = NSKeyedArchiver.archivedData(withRootObject: getData.dbData)
            sendWatchMessage(programData)
            
            let message = ["progData": msgData]
            WCSession.default.sendMessage(message, replyHandler: nil)
        }

        lastMessage = CFAbsoluteTimeGetCurrent()
        
        
    }
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        if(WCSession.isSupported()){
            let session = WCSession.default
            session.delegate = self
            session.activate()
            
            if session.isPaired != true{
                print("Apple watch is not paired")
            }
            if session.isWatchAppInstalled != true{
                print("App is not installed")
            }
        }
        else{
            print("Watch connectivity is not supported")
        }
       initWithDetails()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if getData.dbData != nil
        {
            return (getData.dbData?.count)!
        }
        else
        {
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let tableCell : MyDataTableViewCell = tableView.dequeueReusableCell(withIdentifier: "myCell") as? MyDataTableViewCell ?? MyDataTableViewCell(style: .default, reuseIdentifier: "myCell")
     
     let row = indexPath.row
     let rowData = (getData.dbData?[row])! as NSDictionary
     tableCell.make.text = rowData["Make"] as? String
     tableCell.model.text = rowData["Model"] as? String
     tableCell.year.text = rowData["Year"] as? String
     tableCell.color.text = rowData["Color"] as? String
     tableCell.newORused.text = rowData["New/Used"] as? String
     tableCell.price.text = rowData["Price"] as? String
    tableCell.myLogo.image = UIImage(named: "collage.png")
     
    
        
        
     return tableCell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
   
}
