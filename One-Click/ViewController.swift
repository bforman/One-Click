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
    //var peripheralDesc : String = ""

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("bob")
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
        print(peripheral.description)
        print(advertisementData)
        //DeviceLabel.text = peripheral.description
        centralManager.connectPeripheral(connectingPeripheral, options: nil)
    }
    
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        
        print("Connected to peripheral")
    
        //connectingPeripheral = peripheral
        //centralManager.connectPeripheral(connectingPeripheral, options: nil)
        
        deviceLabel.text = peripheral.description
        
        
        //peripheral.discoverServices(nil)
    }
    
    
    func centralManagerDidUpdateState(central: CBCentralManager) {
        print("checking state")
        switch (central.state) {
        case .PoweredOff:
            status = "CoreBluetooth BLE hardware is powered off"
            
        case .PoweredOn:
            status = "CoreBluetooth BLE hardware is powered on and ready"
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
            //print("in")
            discoverDevices()
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var messageField: UILabel!

    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var deviceLabel: UILabel!
    
    @IBAction func buttonPressed(sender: UIButton) {
        messageField.text = "Message from Arduino will go here!"
        //DeviceLabel.text = "Bob Saget"
    }
    @IBAction func searchPressed(sender: UIButton) {
        statusLabel.text = status
        if connectingPeripheral != nil {
            deviceLabel.text = connectingPeripheral.name
        }
    }
  
}

