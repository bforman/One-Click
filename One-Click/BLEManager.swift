//
//  BLEManager.swift
//  One-Click
//
//  Created by Ben Forman on 1/28/16.
//  Copyright © 2016 App State. All rights reserved.
//

import Foundation
import CoreBluetooth

class BLEManager {
    var status : String
    var centralManager : CBCentralManager!
    var bleHandler : BLEHandler!
    init () {
        self.bleHandler = BLEHandler()
        self.status = ""
        //print(self.status)
        self.centralManager = CBCentralManager(delegate: self.bleHandler, queue: nil)
    }
    
    /*func sendStatus() -> String{
        return status
    }*/

}