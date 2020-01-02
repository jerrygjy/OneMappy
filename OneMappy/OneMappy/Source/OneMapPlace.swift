//
//  OneMapPlace.swift
//  onemobileapp
//
//  Created by Jerry Goh on 12/9/18.
//  Copyright © 2018 govtech. All rights reserved.
//

import UIKit

@objc(OneMapPlace)
open class OneMapPlace: NSObject, NSCoding {

    open var id = ""
    
    open  var BUILDINGNAME: String = ""
    open  var BLOCK: String = ""
    open  var ROAD: String = ""
    open var POSTALCODE: String = ""
    open var XCOORD: String = ""
    open var YCOORD: String = ""
    open var LATITUDE: String = ""
    open var LONGITUDE: String = ""
    //Only in search
    open var ADDRESS: String = ""
    open var SEARCHVAL: String = ""
    //Additional Info
    open var Location: String = ""
    open var counter = 0
    //Purpose
    open var Purpose: String = ""
    
    override init() {
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.BUILDINGNAME = aDecoder.decodeObject(forKey: "BUILDINGNAME") as? String ?? ""
        self.BLOCK = aDecoder.decodeObject(forKey: "BLOCK")  as? String ?? ""
        self.ROAD = aDecoder.decodeObject(forKey: "ROAD") as? String ?? ""
        self.POSTALCODE = aDecoder.decodeObject(forKey: "POSTALCODE")  as? String ?? ""
        self.XCOORD = aDecoder.decodeObject(forKey: "XCOORD") as? String ?? ""
        self.YCOORD = aDecoder.decodeObject(forKey: "YCOORD")  as? String ?? ""
        self.LATITUDE = aDecoder.decodeObject(forKey: "LATITUDE") as? String ?? ""
        self.LONGITUDE = aDecoder.decodeObject(forKey: "LONGITUDE")  as? String ?? ""
        self.ADDRESS = aDecoder.decodeObject(forKey: "ADDRESS")  as? String ?? ""
        self.SEARCHVAL = aDecoder.decodeObject(forKey: "SEARCHVAL")  as? String ?? ""
        self.Purpose =  aDecoder.decodeObject(forKey: "Purpose") as? String ?? ""
        self.Location =  aDecoder.decodeObject(forKey: "Location") as? String ?? ""
    }
    
    open func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.BUILDINGNAME, forKey: "BUILDINGNAME")
        aCoder.encode(self.BLOCK, forKey: "BLOCK")
        aCoder.encode(self.ROAD, forKey: "ROAD")
        aCoder.encode(self.POSTALCODE, forKey: "POSTALCODE")
        aCoder.encode(self.XCOORD, forKey: "XCOORD")
        aCoder.encode(self.YCOORD, forKey: "YCOORD")
        aCoder.encode(self.LATITUDE, forKey: "LATITUDE")
        aCoder.encode(self.LONGITUDE, forKey: "LONGITUDE")
        aCoder.encode(self.ADDRESS, forKey: "ADDRESS")
        aCoder.encode(self.SEARCHVAL, forKey: "SEARCHVAL")
        aCoder.encode(self.Purpose, forKey: "Purpose")
        aCoder.encode(self.Location, forKey: "Location")
    }
    
    func getLocationString() -> String {
        
        //Formulating
        
        var addressStr = ""
        if self.Location.isEmpty == false {
            return self.Location
        }
        
        if self.BUILDINGNAME.isEmpty == false && self.BUILDINGNAME != "NIL" && self.BUILDINGNAME != "null" {
            addressStr += self.BUILDINGNAME
        }
        if self.BLOCK.isEmpty == false && self.BLOCK != "NIL" && self.BLOCK != "null" {
            addressStr += " " + self.BLOCK
        }
        if self.ROAD.isEmpty == false && self.ROAD != "NIL" && self.ROAD != "null" {
            addressStr += " " + self.ROAD
        }
        if self.POSTALCODE.isEmpty == false && self.POSTALCODE != "NIL" && self.POSTALCODE != "null" {
            addressStr += " Singapore " + self.POSTALCODE
        }
        
        if addressStr.isEmpty == true && self.LATITUDE.isEmpty == false && self.LONGITUDE.isEmpty == false {
            addressStr = String(format: "%@,%@", self.LATITUDE, self.LONGITUDE)
        }
        
        self.Location = addressStr
        return self.Location
    }
    
    func getAddress() -> String {
        var addressStr = ""
        
        if self.BUILDINGNAME.isEmpty == false && self.BUILDINGNAME != "NIL" && self.BUILDINGNAME != "null"{
            return self.BUILDINGNAME
        }
        
        if self.BLOCK.isEmpty == false && self.BLOCK != "NIL" && self.BLOCK != "null" {
            addressStr += self.BLOCK
        }
        if self.ROAD.isEmpty == false && self.ROAD != "NIL" && self.ROAD != "null" {
             addressStr += " " + self.ROAD
        }
        if self.POSTALCODE.isEmpty == false && self.POSTALCODE != "NIL" && self.POSTALCODE != "null" {
           addressStr += " Singapore " + self.POSTALCODE
        }

        if addressStr.isEmpty == true && self.LATITUDE.isEmpty == false && self.LONGITUDE.isEmpty == false {
            addressStr = String(format: "%@,%@", self.LATITUDE, self.LONGITUDE)
        }
        return addressStr
    }
    
}
