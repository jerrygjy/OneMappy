//
//  OneMapRoute.swift
//  onemobileapp
//
//  Created by Jerry Goh on 12/9/18.
//  Copyright © 2018 govtech. All rights reserved.
//

import UIKit

class OneMapRoute: NSObject {

    //Distance should be taken with following priorities
    //1. PhyRoute, 2. master route, 3.  alternate route
     var distanceToUse: String = ""
    
    var status_message: String = ""
    var routeGeometryString: String = ""
    var status: String = ""
    var route_instructions: Array = Array<Array<String>>()
    var route_name: Array = Array<String>()
    var route_summary: Dictionary = Dictionary<String, Any>()
    var viaRoute: String = ""
    var subtitle: String = ""
    
    var phy_status_message: String = ""
    var phy_routeGeometryString: String = ""
    var phy_status: String = ""
    var phy_route_instructions: Array = [Array<String>]()
    var phy_route_name: Array = Array<String>()
    var phy_route_summary: Dictionary = Dictionary<String, Any>()
    var phy_viaRoute: String = ""
    var phy_subtitle: String = ""
    
    public override init() {}
    
}
