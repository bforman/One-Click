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
    var characteristic : CBCharacteristic!
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
                let rx:[CBUUID] = [CBUUID(string: RX)]
                connectingPeripheral.discoverCharacteristics(rx, forService: service)
                print("found RX characteristic")
            }
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        print("here")
        characteristic = service.characteristics?.first
        print(characteristic)
        var array:[UInt8] = [0x00, 0x01, 0x03]
        let data = NSData(bytes: &array, length: array.count)
        print(data)
        connectingPeripheral.writeValue(data, forCharacteristic: characteristic, type: CBCharacteristicWriteType.WithoutResponse)
        print("-------------------------------------")
        print("written")

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


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBOutlet weak var messageField: UILabel!

    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var deviceLabel: UILabel!
    
    @IBAction func buttonPressed(sender: UIButton) {
        messageField.text = "Message from Arduino will go here!"
    }
    @IBAction func searchPressed(sender: UIButton) {
        deviceLabel.text = name
    }
  
}

