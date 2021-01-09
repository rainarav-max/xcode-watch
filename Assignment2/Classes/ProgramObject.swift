//
//  ProgramObject.swift
//  Assignment2
//
//  Created by Xcode User on 2020-11-29.
//  Copyright © 2020 Xcode User. All rights reserved.
//

import UIKit

class ProgramObject: NSObject {
    let  getdata = GetData()
    var make : String?
    var model : String?
    var year : String?
    var colour : String?
    var newUsed : String?
    var price : String?
    
    
    func initWithData( make:String,
                       model:String,
                       year:String,
                       colour:String,
                       newUsed:String,
                       price:String)
        
    {
        
        self.make = make
        self.model = model
        self.year = year
        self.colour = colour
        self.newUsed = newUsed
        self.price = price
       
        
    }
    
    // step 3c -> create these two methods to handle serialization of data between
    // phone and watch.
    required convenience init?(coder decoder: NSCoder) {
        
        guard let make = decoder.decodeObject(forKey: "make") as? String,
            let model = decoder.decodeObject(forKey: "model") as? String,
            let year = decoder.decodeObject(forKey: "year") as? String,
            let colour = decoder.decodeObject(forKey: "colour") as? String,
            let newUsed = decoder.decodeObject(forKey: "newUsed") as? String,
            let price = decoder.decodeObject(forKey: "price") as? String
            else { return nil }
        
        
        // note this will cause crash if its not in here exactly as is
        self.init()
        self.initWithData(
            make: make as String,
            model: model as String,
            year : year as String,
            colour : colour as String,
            newUsed : newUsed as String,
            price : price as String
            // myLogo : myLogo
        )
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.make, forKey: "make")
        coder.encode(self.model, forKey: "model")
        coder.encode(self.year, forKey: "year")
        coder.encode(self.colour, forKey: "colour")
        coder.encode(self.newUsed, forKey: "newUsed")
        coder.encode(self.price, forKey: "price")
        // coder.encode(self.myLogo, forKey: "myLogo")
        
    }
}
