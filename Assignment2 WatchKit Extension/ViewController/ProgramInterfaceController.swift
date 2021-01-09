//
//  ProgramInterfaceController.swift
//  Assignment2 WatchKit Extension
//
//  Created by Xcode User on 2020-11-26.
//  Copyright © 2020 Xcode User. All rights reserved.
//
import WatchKit
import Foundation
import WatchConnectivity


class ProgramInterfaceController: WKInterfaceController, WCSessionDelegate {
    
    @IBOutlet var progTable : WKInterfaceTable!
    let getdata = GetData()
    var programs : [ProgramObject] = []
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        
        var replyValues = Dictionary<String, AnyObject>()
        
        let loadedData = message["progData"]
        
        let loadedPerson = NSKeyedUnarchiver.unarchiveObject(with: loadedData as! Data) as? [ProgramObject]
        //   let loadedPerson = NSKeyedUnarchiver.unarchiveObject(with: loadedData as! Data) as? [ProgramObject]
        //programs = getdata.dbData as! [ProgramObject]
        
        programs = loadedPerson!
        
        replyValues["status"] = "Program Received" as AnyObject?
        replyHandler(replyValues)
    }
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
        if (WCSession.isSupported()) {
            let session = WCSession.default
            session.delegate = self
            session.activate()
            
            
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if (WCSession.default.isReachable) {
            
            let message = ["getProgData": [:]]
            WCSession.default.sendMessage(message, replyHandler: { (result) -> Void in
                
                if result["progData"] != nil
                {
                    
                    let loadedData = result["progData"]
                    
                    
                    // step 6d - deserialize the data from the watch
                    NSKeyedUnarchiver.setClass(ProgramObject.self, forClassName: "ProgramObject")
                    // causes app crash because decode not linked properly error
                    // above line of code needed to prevent this crash
                    let loadedPerson = (NSKeyedUnarchiver.unarchiveObject(with: loadedData as! Data)) as? [NSDictionary]
                    
                    self.progTable.setNumberOfRows(loadedPerson!.count,
                                                   withRowType: "ProgRowController")
                    //print(car)
                    for index in 0..<loadedPerson!.count{
                        print("\(index)")
                        let row = self.progTable.rowController(at: index) as! ProgRowController
                        
                        let rowData = (loadedPerson![index]) as NSDictionary
                        
                        let make = (rowData["Make"] as? String)!
                        let model = (rowData["Model"] as? String)!
                        let year = (rowData["Year"] as? String)!
                        let colour = (rowData["Color"] as? String)!
                        let new_used = (rowData["New/Used"] as? String)!
                        let price = (rowData["Price"] as? String)!
                        
                        
                     
                        // let carInfo = make + " " + model
                        
                        row.lblMake.setText("make: \(make)")
                        row.lblModel.setText("model: \(model)")
                        row.lblYear.setText("year: \(year)")
                        row.lblColour.setText("colour: \(colour)")
                        row.lblNew_Used.setText("new_used: \(new_used)")
                        row.lblPrice.setText("price: \(price)")
                        
                        
                    }
                    
                }
                
                
            }, errorHandler: { (error) -> Void in
                // TODO: Handle error - iPhone many not be reachable
                print(error)
            })
            
            
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
}
