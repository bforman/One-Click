//
//  BLEHandler.swift
//  One-Click
//
//  Created by Ben Forman on 1/28/16.
//  Copyright © 2016 App State. All rights reserved.
//

import Foundation
import CoreBluetooth

class BLEHandler : NSObject, CBCentralManagerDelegate {
    var stat : String
    override init(){
        self.stat = "lololol"
        super.init()
        //self.stat = "bob"
    }
    
    func centralManagerDidUpdateState(central: CBCentralManager){
        //var stat : String
        switch (central.state) {
        case .Unsupported:
            stat = "BLE is unsupported"
            if let lab = ViewController().statusLabel {
                lab.text = "BLE is unsupported"
            }
            //print(stat)
            print("BLE is unsupported")
        case .Unauthorized:
            print("BLE is unauthorized")
        case .Unknown:
            print("BLE is unknown")
        case .Resetting:
            print("BLE is resetting")
        case .PoweredOff:
            print("BLE is powered off")
        case .PoweredOn:
            print("BLE is powered on")
            //stat = "BLE is powered on"
            print("Scanning for local devices...")
            central.scanForPeripheralsWithServices(nil, options: nil)
        default:
            print("BLE default")
        
        }
    }
    
    func centralManager(central: CBCentralManager!,
        didDiscoverPeripheral peripheral: CBPeripheral!,
        advertisementData: [String : AnyObject]!,
        RSSI: NSNumber!)
    {
        print("\(peripheral.name) : \(RSSI) dbm")
    }
    
}
