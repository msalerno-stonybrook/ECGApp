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
    
    var ECGsensor : CBPeripheral!
    var CBManager : CBCentralManager!

    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    // If disconnected, start searching again
    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        print("Disconnected")
        // go back to table view controller when disconnected
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
