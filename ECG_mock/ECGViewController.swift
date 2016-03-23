//
//  ECGViewController.swift
//  ECG_mock
//
//  Created by Helmut Strey on 2/23/16.
//  Copyright © 2016 ___STREYLAB___. All rights reserved.
//

import UIKit
import CoreBluetooth

class ECGViewController: UIViewController, CBPeripheralDelegate, CBCentralManagerDelegate {
    
    @IBOutlet weak var dataLabel: UILabel!
    
    var ECGsensor : CBPeripheral!
    var CBManager : CBCentralManager!
    let ServicesList = [CBUUID(string:"92F4B880-31B5-11E3-9C7D-0002A5D5C51B"),CBUUID(string:"F9266FD7-EF07-45D6-8EB6-BD74F13620F9")]
    let CharacteristicsList = [CBUUID(string:"C7BC60E0-31B5-11E3-9389-0002A5D5C51B"),CBUUID(string:"4585C102-7784-40B4-88E1-3CB5C4FD37A3")]

    override func viewDidLoad() {
        super.viewDidLoad()
        // when view loads connect to peripheral that was selected
        print("ECG View loads")
        CBManager.delegate = self
        CBManager.connectPeripheral(ECGsensor, options: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    /******* CBCentralManagerDelegate *******/
    
    // Check status of BLE hardware
    func centralManagerDidUpdateState(central: CBCentralManager) {
        if central.state == CBCentralManagerState.PoweredOn {
            print("Central Manager is Powered on...")
        }
        else {
            // Can have different conditions for all states if needed - show generic alert for now
            print("Error: Bluetooth switched off or not initialized")
        }
    }
    
    // Discover services of the peripheral
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        print("Discovering peripheral services")
        ECGsensor = peripheral
        ECGsensor.delegate = self
        ECGsensor.discoverServices(nil)
    }
    
    // If disconnected, start searching again
    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        print("Disconnected")
        // go back to table view controller when disconnected
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    /******* CBCentralPeripheralDelegate *******/
    
    // once connected the peripheral is reporting back with services
    // check whether BLESensorService exists and if yes then discover its characteristics
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        print("connected...")
        print("found services")
        for service in peripheral.services! {
            let thisService = service as CBService
            print("found service \(thisService.UUID)")
            if ServicesList.contains(thisService.UUID) {
                // is any of the services the BLESensor service?
                print("found ECGSensor service!")
                peripheral.discoverCharacteristics(nil, forService: thisService)
            }
        }

    }
    
    // this function is called when the device returns discovered characteristics
    // set to notify if the proper characteristic is found
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        for charateristic in service.characteristics! {
            let thisCharacteristic = charateristic as CBCharacteristic
            print("found characteristic \(thisCharacteristic.UUID)")
            if CharacteristicsList.contains(thisCharacteristic.UUID) {
                // Enable Sensor Notification
                peripheral.setNotifyValue(true, forCharacteristic: thisCharacteristic)
            }
        }
        
    }
    
    // this function is called then a characteristic was updated
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        
        print("got some data...")
        
        if CharacteristicsList.contains(characteristic.UUID) {
            print("got BLE sensor data")
            dataLabel.text = characteristic.value!.hexadecimalString as String
            
        }
    }



}
