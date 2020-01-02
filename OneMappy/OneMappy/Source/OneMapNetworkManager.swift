//
//  OneMapNetworkManager.swift
//  OneMappy
//
//  Created by Jerry Goh on 2/1/20.
//  Copyright © 2020 Jerry Goh. All rights reserved.
//

import UIKit

class OneMapNetworkManager: NSObject, URLSessionDelegate, URLSessionDataDelegate {
var queue = OperationQueue()
    static let sharedInstance = OneMapNetworkManager()
}
