//
//  ECGViewController.swift
//  ECG_mock
//
//  Created by Helmut Strey on 2/23/16.
//  Copyright © 2016 ___STREYLAB___. All rights reserved.
//

import UIKit
import CoreBluetooth

class ECGViewController: UIViewController, CBPeripheralDelegate, CBCentralManagerDelegate, ECGDataSource {
    
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var plotView: PlotView!
    
    var ECGsensor : CBPeripheral!
    var CBManager : CBCentralManager!
    let ServicesList = [CBUUID(string:"92F4B880-31B5-11E3-9C7D-0002A5D5C51B"),CBUUID(string:"F9266FD7-EF07-45D6-8EB6-BD74F13620F9"),CBUUID(string:"FE84")]
    let CharacteristicsList = [CBUUID(string:"C7BC60E0-31B5-11E3-9389-0002A5D5C51B"),CBUUID(string:"4585C102-7784-40B4-88E1-3CB5C4FD37A3"), CBUUID(string:"2D30C082-F39F-4CE6-923F-3484EA480596")]
    
    var data = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // when view loads connect to peripheral that was selected
        print("ECG View loads")
        CBManager.delegate = self
        CBManager.connect(ECGsensor, options: nil)
        plotView.delegate = self
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
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        let state = central.state
        if #available(iOS 10.0, *) {
            if state == CBManagerState.poweredOn {
                print("Central Manager is Powered on...")
            }
            else {
                // Can have different conditions for all states if needed - show generic alert for now
                print("Error: Bluetooth switched off or not initialized")
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    // Discover services of the peripheral
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Discovering peripheral services")
        ECGsensor = peripheral
        ECGsensor.delegate = self
        ECGsensor.discoverServices(nil)
    }
    
    // If disconnected, start searching again
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected")
        // go back to table view controller when disconnected
        self.dismiss(animated: true, completion: nil)
    }
    /******* CBCentralPeripheralDelegate *******/
    
    // once connected the peripheral is reporting back with services
    // check whether BLESensorService exists and if yes then discover its characteristics
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("connected...")
        print("found services")
        for service in peripheral.services! {
            let thisService = service as CBService
            print("found service \(thisService.uuid)")
            if ServicesList.contains(thisService.uuid) {
                // is any of the services the BLESensor service?
                print("found ECGSensor service!")
                peripheral.discoverCharacteristics(nil, for: thisService)
            }
        }

    }
    
    // this function is called when the device returns discovered characteristics
    // set to notify if the proper characteristic is found
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for charateristic in service.characteristics! {
            let thisCharacteristic = charateristic as CBCharacteristic
            print("found characteristic \(thisCharacteristic.uuid)")
            if CharacteristicsList.contains(thisCharacteristic.uuid) {
                // Enable Sensor Notification
                peripheral.setNotifyValue(true, for: thisCharacteristic)
            }
        }
        
    }
    
    // this function is called then a characteristic was updated
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        if CharacteristicsList.contains(characteristic.uuid) {
            print("got BLE sensor data")
            let dataReceived = characteristic.value!
            dataLabel.text = dataReceived.hexadecimalString as String
            
            var bytes = [UInt8](repeating: 0, count: dataReceived.count)
            (dataReceived as NSData).getBytes(&bytes, length: dataReceived.count)

            for index in 0...dataReceived.count/2-1 {
//                let dataPoint = Int(bytes[index*2])/16+(Int(bytes[index*2+1]) & 255)*16
                let dataPoint = Int(bytes[index*2])+(Int(bytes[index*2+1]) & 255)*256
                data.append(dataPoint)
            }
            
            plotView.setNeedsDisplay()            
        }
    }

    func dataYforWidth(_ width: Int) -> [Int] {
        return data
    }

}
