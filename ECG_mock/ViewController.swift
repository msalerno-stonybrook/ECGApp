//
//  ViewController.swift
//  ECG_mock
//
//  Created by Helmut Strey on 1/25/16.
//  Copyright © 2016 ___STREYLAB___. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate, UITableViewDataSource, UITableViewDelegate {
    
    let kBLESensorServiceUUIDString = "92F4B880-31B5-11E3-9C7D-0002A5D5C51B"
    let kBLESensorCharacteristicDataString = "C7BC60E0-31B5-11E3-9389-0002A5D5C51B"

    @IBOutlet weak var tableView:UITableView!
    
    //BLE
    var centralManager : CBCentralManager!
    var ECGsensorPeripheral : CBPeripheral!

    var BLEdevices = [CBPeripheral]()
    var refreshTimer: NSTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.addSubview(self.refreshControl)
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    // pull to refresh controller
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()
    
    // Table Data Source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BLEdevices.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
        if let BLEname = BLEdevices[indexPath.row].name {
            cell.textLabel?.text = BLEname
        }
        
        let myImage = UIImage(named: "Cell_Icons")
        cell.imageView?.image = myImage
        
        return cell
    }
    
    // pull to refresh
    func handleRefresh(refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        print("Scanning...")
        BLEdevices.removeAll()
        centralManager.scanForPeripheralsWithServices(nil, options: nil)
        refreshTimer=NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "afterScanning",userInfo: nil, repeats: false)
    }
    
    func afterScanning() {
        print("finished scanning")
        centralManager.stopScan()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
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
    
    // Check out the discovered peripherals to find Sensor Tag
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        print("Found device: ",advertisementData)
        if let nameOfDeviceFound = (advertisementData as NSDictionary).objectForKey(CBAdvertisementDataLocalNameKey) as? NSString {
            if (nameOfDeviceFound.hasPrefix("ECG-Sensor")) {
                // add peripheral to BLE devices array if not already in there
                if !BLEdevices.contains(peripheral) {
                    BLEdevices.append(peripheral)
                    self.tableView.reloadData()
                }
            }

        }
    }
    
    // Discover services of the peripheral
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        print("Discovering peripheral services")
        peripheral.discoverServices(nil)
    }
    
    
    // If disconnected, start searching again
    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        print("Disconnected")
        central.scanForPeripheralsWithServices(nil, options: nil)
    }
    
    /******* CBCentralPeripheralDelegate *******/
     
     // Check if the service discovered is valid i.e. one of the following:
     // IR Temperature Service
     // Accelerometer Service
     // Humidity Service
     // Magnetometer Service
     // Barometer Service
     // Gyroscope Service
     // (Others are not implemented)
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        print("Looking at peripheral services")
    }
    
    
    // Enable notification and sensor for each characteristic of valid service
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        
        print("Enabling sensors")
        
    }
    
    // Get data values when they are updated
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        
        print("Connected")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

