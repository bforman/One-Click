//
//  ViewController.swift
//  One-Click
//
//  Created by Ben Forman on 1/21/16.
//  Copyright (c) 2016 App State. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, CBCentralManagerDelegate {

    
    var centralManager:CBCentralManager!
    var connectingPeripheral:CBPeripheral!
    var blueToothReady = false
    var status : String = ""

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        if (connectingPeripheral.name == "ble_led") {
            centralManager.stopScan()
            centralManager.connectPeripheral(connectingPeripheral, options: nil)
        }
    }
    
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        
        print("Connected to peripheral")
        
        deviceLabel.text = "Connected to " + peripheral.name!
        print(peripheral.description)
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
        statusLabel.text = status
        if connectingPeripheral != nil {
            deviceLabel.text = connectingPeripheral.name
        }
    }
  
}

