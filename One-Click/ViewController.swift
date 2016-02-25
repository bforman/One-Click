//
//  ViewController.swift
//  One-Click
//
//  Created by Ben Forman on 1/21/16.
//  Copyright (c) 2016 App State. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {

    
    var centralManager:CBCentralManager!
    var connectingPeripheral:CBPeripheral!
    var blueToothReady = false
    var status : String = ""
    var name : String = ""
    var rx : CBCharacteristic!
    var tx : CBCharacteristic!
    let serviceID = "713D0000-503E-4C75-BA94-3148F18D941E"
    let TX = "713D0002-503E-4C75-BA94-3148F18D941E"
    let RX = "713D0003-503E-4C75-BA94-3148F18D941E"

    
    
    override func viewDidLoad() {
        print("View Loaded")
        super.viewDidLoad()
        deviceLabel.text = "Searching for BLE Shield"
        startUpCentralManager()
    }
    
    
    func startUpCentralManager() {
        print("Initializing central manager")
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func discoverDevices() {
        print("discovering devices")
        centralManager.scanForPeripheralsWithServices(nil, options: nil)
        print("done scanning")
    }
    
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String: AnyObject], RSSI: NSNumber)
    {
        connectingPeripheral = peripheral
        print("peripheral found")
        print(peripheral.name)
        if (connectingPeripheral.name == "BLE Shield") {
            centralManager.stopScan()
            centralManager.connectPeripheral(connectingPeripheral, options: nil)
        }
    }
    
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        
        print("Connected to peripheral")
        
        name = "Connected to " + connectingPeripheral.name!
        print(connectingPeripheral.description)
        print("Discovering Services...")
        connectingPeripheral.delegate = self
        let services:[CBUUID] = [CBUUID(string: serviceID)]
        print(services)
        connectingPeripheral.discoverServices(services)
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        print("Discovered Services")
        print(connectingPeripheral.services)
        for service in connectingPeripheral.services! {
            print(service.UUID)
            if service.UUID.UUIDString == "713D0000-503E-4C75-BA94-3148F18D941E" {
                connectingPeripheral.discoverCharacteristics(nil, forService: service)
            }
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        print("writing data")
        rx = service.characteristics?.first
        tx = service.characteristics?.last
        print(tx)
        let string = "hello arduino"
        let data = string.dataUsingEncoding(NSUTF8StringEncoding)
        connectingPeripheral.writeValue(data!, forCharacteristic: rx, type: CBCharacteristicWriteType.WithoutResponse)
        print("-------------------------------------")
        print("written")
        let yes : Bool = true
        connectingPeripheral.setNotifyValue(yes, forCharacteristic: tx)

    }
    
    func centralManagerDidUpdateState(central: CBCentralManager) {
        print("checking state")
        switch (central.state) {
        case .PoweredOff:
            status = "CoreBluetooth BLE hardware is powered off"
            
        case .PoweredOn:
            status = "CoreBluetooth powered on and ready"
            blueToothReady = true;
            
        case .Resetting:
            status = "CoreBluetooth BLE hardware is resetting"
            
        case .Unauthorized:
            status = "CoreBluetooth BLE state is unauthorized"
            
        case .Unknown:
            status = "CoreBluetooth BLE state is unknown"
            
        case .Unsupported:
            status = "CoreBluetooth BLE hardware is unsupported"
        }
        
        if blueToothReady {
            discoverDevices()
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        print("Arduino updated tx")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBOutlet weak var messageField: UILabel!

    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var deviceLabel: UILabel!
    
    @IBAction func buttonPressed(sender: UIButton) {
        let datastring = NSString(data: tx.value!, encoding: NSASCIIStringEncoding) as! String
        print(datastring)
        messageField.text = "Arduino Message: " + datastring


    }


    @IBAction func searchPressed(sender: UIButton) {
        deviceLabel.text = name
    }
  
}

